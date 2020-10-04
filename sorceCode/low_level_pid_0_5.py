"""
This code is for Raspi Client
Hardware list:
    1. I2c Multiplx
    2. 3 DACs
    3. 3 Regulator SMC ITV050
    4. 1 ADC
    6. 1 24V power supply
    7. 1 12V supply for Raspi
"""
import numpy as np
import zmq
import Adafruit_MCP4725 as DAC
from ads1015 import ADS1015 
import pickle
import zlib
import tca9548a
from time import time, sleep
import threading
class raspi_client(object):
    """docstring for ClassName"""
    def __init__(self):

        #ZMQ
        context = zmq.Context()
        self.socket0 = context.socket(zmq.PUB)
        self.socket0.setsockopt(zmq.CONFLATE,True)
        # self.socket0.bind("tcp://127.0.0.1:3333")## PUB pd pm 
        self.socket0.bind("tcp://10.203.54.18:3333")## PUB pd pm 

        self.socket1 = context.socket(zmq.SUB)
        self.socket1.setsockopt(zmq.CONFLATE,1)
        self.socket1.setsockopt(zmq.SUBSCRIBE,'')
        self.socket1.connect("tcp://10.203.53.226:4444")## sub pd 
        
        self.tca_driver = tca9548a.TCA9548A(0x70)
        self.tca_driver.set_channel(0,1)
        self.dac_0=DAC.MCP4725()
        self.dac_0.set_voltage(0)
        self.tca_driver.set_channel(0,0)
        
        self.tca_driver.set_channel(1,1)
        self.dac_1=DAC.MCP4725()
        self.dac_1.set_voltage(0)
        self.tca_driver.set_channel(1,0)
        
        self.tca_driver.set_channel(2,1)
        self.dac_2=DAC.MCP4725()
        self.dac_2.set_voltage(0)
        self.tca_driver.set_channel(2,0)
        # ADC and 
        self.adc=ADS1015()
        self.adc.set_mode('single')
        self.adc.set_programmable_gain(6.144)
        self.adc.set_sample_rate(1600)
        # Other
        self.pd_array=np.array([0.,0.,0.])
        self.pm_array=np.array([0.,0.,0.])
        self.pe_max=1.0 #psi 
        self.pm_offset=np.array([0.,0.,0.])
        self.kp=0
        # Thread Setup
        self.th1_flag=True
        self.th2_flag=True
        self.run_event=threading.Event()
        self.run_event.set()
        self.th1=threading.Thread(name='convertPdToVolt',target=self.th_convertPdToVolt)
        self.th2=threading.Thread(name='readADCandPubtoHighLevel',target=self.th_readADCandPubtoHighLevel)

    def send_zipped_pickle(self, obj, flags=0, protocol=-1):
        """pack and compress an object with pickle and zlib."""
        pobj = pickle.dumps(obj, protocol)
        zobj = zlib.compress(pobj)
        self.socket0.send(zobj, flags=flags)

    def recv_zipped_pickle(self,flags=0):
        """reconstruct a Python object sent with zipped_pickle"""
        zobj = self.socket1.recv(flags)
        pobj = zlib.decompress(zobj)
        return pickle.loads(pobj)

    def vout_from_pd(self,line_id,pd):

        # if line_id==0:
        #     channel='in0/gnd'
        # elif line_id==1:
        #     channel='in1/gnd'
        # elif line_id==2:
        #     channel='in2/gnd'
        # else:
        #     channel=None
        # v_in=self.adc.get_voltage(channel=channel)
        # #   pm_array=(np.array([v0])-0.1*5)*4.0/(0.8*5.0)*14.5038# 5V 58 psi
        # # pm=(v_in-0.1*5)*4.0/(0.8*5.0)*14.5038-self.pm_offset[line_id]
        # ### exp id regulator pm
        # pm=v_in*31.13-29.33-self.pm_offset[line_id]

        #pm=(v_in-0.1*5)*4.0/(0.8*5.0)*14.5038
        # pe=pd-pm
        # v_out=abs(pe)/self.pe_max*4095# 0-pe_max maps to 0-5V maps to 0-4095
        u=pd
        # v_out=(u-0.3)/60*4095#regualtor control
        v_out=(u)/60*4095#regualtor control
        # print u,v_out
        if v_out>=4095:
            v_out=4095
        elif v_out<=0:
            v_out=0
        if line_id==0:
            self.tca_driver.set_channel(line_id,1)
            self.dac_0.set_voltage(int(v_out))
            self.tca_driver.set_channel(line_id,0)
        elif line_id==1:
            self.tca_driver.set_channel(line_id,1)
            self.dac_1.set_voltage(int(v_out))
            self.tca_driver.set_channel(line_id,0)
        elif line_id==2:
            self.tca_driver.set_channel(line_id,1)
            self.dac_2.set_voltage(int(v_out))
            self.tca_driver.set_channel(line_id,0)
        # return pm

    def pressure_sensor_cali(self):
        k=1000
        pm_off=np.array([0.,0.,0.])
        for i in range(k):
            v_in_0=self.adc.get_voltage(channel='in0/gnd')
            v_in_1=self.adc.get_voltage(channel='in1/gnd')
            v_in_2=self.adc.get_voltage(channel='in2/gnd')
            # print np.array([v_in_0,v_in_1,v_in_2])
            # pm_off=pm_off+((np.array([v_in_0,v_in_1,v_in_2])-0.1*5)*4.0/(0.8*5.0)*14.5038)
            pm_off=pm_off+(np.array([v_in_0,v_in_1,v_in_2])*31.13-29.33)
        pm_off=pm_off/k
        self.pm_offset=pm_off

    def th_convertPdToVolt(self):
        try:
            while self.run_event.is_set() and self.th1_flag:
                self.pd_array=self.recv_zipped_pickle()
                for kk in range(3):
                    self.vout_from_pd(kk,self.pd_array[kk])
                sleep(0.005)
        except KeyboardInterrupt:
            self.th1_flag=False


    def th_readADCandPubtoHighLevel(self):
        print"Start Pressure Sensor Calibration"
        self.pressure_sensor_cali()
        print self.pm_offset
        try:
            while self.run_event.is_set() and self.th2_flag:
                v_in_0=self.adc.get_voltage(channel='in0/gnd')
                v_in_1=self.adc.get_voltage(channel='in1/gnd')
                v_in_2=self.adc.get_voltage(channel='in2/gnd')
                self.pm_array[0]=v_in_0*31.13-29.33-self.pm_offset[0]
                self.pm_array[1]=v_in_1*31.13-29.33-self.pm_offset[1]
                self.pm_array[2]=v_in_2*31.13-29.33-self.pm_offset[2]
                msg=np.concatenate((self.pd_array, self.pm_array), axis=None)
                self.send_zipped_pickle(msg)
                sleep(0.005)    
        except KeyboardInterrupt:
            self.th2_flag=False
def main():
    try:
        r_client=raspi_client()
        r_client.th1.start()
        sleep(0.5)
        r_client.th2.start()
        while 1:
            pass
    except KeyboardInterrupt:
        r_client.run_event.clear()
        # pd_array=np.array([0.,0.,0.])
        # for kk in range(3):
        #     bahaha=r_client.vout_from_pd(kk,0.)
        exit()

if __name__ == '__main__':
    main()

        

        
