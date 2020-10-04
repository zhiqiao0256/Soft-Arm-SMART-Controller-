"""
This code is the PC Client

"""
import numpy as np
import zmq
import pickle
import zlib
from time import time, sleep
import threading
import math
class pc_client(object):
    """docstring for pc_client"""
    def __init__(self):
        """ Select use mocap or not"""
        self.flag_use_mocap=1

        """ Initiate ZMQ communication"""
        context = zmq.Context()
        self.socket0 = context.socket(zmq.PUB)
        self.socket0.setsockopt(zmq.CONFLATE,True)
        self.socket0.bind("tcp://10.203.53.226:4444")## PUB pd to Raspi Client

        self.socket1 = context.socket(zmq.PUB)##PUb to Record
        self.socket1.setsockopt(zmq.CONFLATE,True)
        self.socket1.bind("tcp://127.0.0.1:5555")

        self.socket2=context.socket(zmq.SUB) ### sub mocap data
        self.socket2.setsockopt(zmq.SUBSCRIBE,'')
        self.socket2.setsockopt(zmq.CONFLATE,True)

        if self.flag_use_mocap == True:
            self.socket2.connect("tcp://127.0.0.1:3885")
            print "Connected to mocap"

        self.socket3=context.socket(zmq.SUB) ### sub Raspi Client
        self.socket3.setsockopt(zmq.SUBSCRIBE,'')
        self.socket3.setsockopt(zmq.CONFLATE,True)
        # self.socket3.setsockopt(zmq.RCVTIMEO,10000)
        self.socket3.connect("tcp://10.203.54.18:3333")

        """ Format recording """
        self.pd_pm_array=np.array([0.]*6) #pd1 pd2 pd3 + pm1 +pm2 +pm3 (psi)
        self.array2setswithrotation=np.array([0.]*14)# x y z qw qx qy qz x1 y1 z1 qw1 qx1 qy1 qz1
        self.array2setsRecord=np.array([0.]*39)#t pd1 pd2 pd3 + pm1 +pm2 +pm3 + positon +orintation

        """ Thearding Setup """
        self.th1_flag=True
        self.th2_flag=True
        self.run_event=threading.Event()
        self.run_event.set()
        self.th1=threading.Thread(name='raspi_client',target=self.th_pub_raspi_client_pd)
        self.th2=threading.Thread(name='mocap',target=self.th_sub_pub_mocap)

        """Initialize SMC Parameter """
        self.m0=0.35# segment weight kg
        self.g=9.8  # gravity m/s^2
        self.L=0.185# segment length m
        self.triangleEdgeLength= 0.07 # m
        self.actuatorWidth= 0.015 # m
    	self.R_f= math.sqrt(3.0)/6*self.triangleEdgeLength+self.actuatorWidth= 0.015 # distribution radius of force
    	self.offsetAngle_p1=math.radians(150) # deg2rad(150)
    	self.x1_old=0. # state for last iteration
    	self.x2_old=0. # state for last iteration
    	self.x1_current=0. # state for current iteration
    	self.x2_current=0. # state for current iteration
    	self.x1_error_old=0.   # error for last iteration
    	self.x1_error_current=0.   # error for current iteration
    	self.x1_dot_error=0. # error derivative for current iteration
    	self.alpha0=0. # scaler of torque
    	self.k0=0. # Nm/rad
    	self.b0=0. # Nm/(rad/s)
    	self.delta_k_max=0. # bonded uncertainty for k
    	self.detla_b_max=0. # bonded uncertainty for b
    	self.input_pressure_limit_psi= 0. # input limit of pressure psi
    	self.smc_lambda=10. # sliding surface gain
    	self.smc_eta=10. # reaching speed of sliding surface

    def th_pub_raspi_client_pd(self):
            while self.run_event.is_set() and self.th1_flag:
                try:
                    self.th1_flag=False
                    self.th2_flag=False
                except KeyboardInterrupt:
                    self.th1_flag=False
            print "Press Ctrl+C to Stop"
            
    def th_sub_pub_mocap(self):# thread config of read data from mocap and send packed msg to record file.
        try:
            while self.run_event.is_set() and self.th2_flag:
                if self.flag_use_mocap == True:
                    self.array2setswithrotation=self.recv_cpp_socket2()
                self.pd_pm_array=self.recv_zipped_socket3()
                self.array2setsRecord=np.concatenate((self.pd_pm_array, self.array2setswithrotation), axis=None)
                self.send_zipped_socket1(self.array2setsRecord)
                # sleep(0.005)
        except KeyboardInterrupt:
            self.th2_flag=False
	def getThetaPhiFromXYZ(self):
		# get top(x,y,z) bottom (x,y,z)
		
		# Rotate to algorithm frame

		# calculate phi rad

		# calculate theta rad

    def getR0fromPhiAndTheta(self):
		# calculate peaks of triangle

		# calculate intersection point on each edge

		# calculate R0 in base frame

	def calculateControlInput(self):

		# velocity estimation




    def step_response(self,pd_array,step_time):
            for i in range(int(step_time/0.005)):
                if self.th1_flag:
                    self.send_zipped_socket0(pd_array)
                    sleep(0.005)

    def ramp_response(self,start_array,end_array,ramp_time):
        for i in range(int(ramp_time/0.005)):
            if self.th1_flag:
                pd_array=start_array+(end_array-start_array)/ramp_time*i*0.005
                self.send_zipped_socket0(pd_array)
                sleep(0.005)

    def sine_response(self,A_array,freq_array,B_array,sine_time):
        for i in range(int(sine_time/0.005)):
            if self.th1_flag:
                pd_array=A_array*np.cos(2.0*np.pi*freq_array*0.005*i)+B_array
                self.send_zipped_socket0(pd_array)
                sleep(0.005)

    def sum_of_sine(self,A,B,f_f,f_0,t_total,p23):
        t0=time()
        t_f=t0+t_total
        while time()<t_f:
            t=time()-t0
            f_t=(f_f-f_0)/t_total*t
            p1=A*np.sin(2*np.pi*f_t*t)+B
            pd_array=np.array([p1,p23,p23])
            self.send_zipped_socket0(pd_array)
            # print p1
            sleep(0.005)

    def sum_of_sine2(self,f_f,f_0,t_total):
        t0=time()
        t_f=t0+t_total
        p1=0.
        numOfSines=10
        ftArray=np.linspace(f_0,f_f,num=numOfSines)
        phasArray=2.0*np.pi*np.random.random_sample((numOfSines,))
        while time()<t_f:
            t=time()-t0
            p1=0.
            i=0
            for f_t in ftArray:
                p1=p1+25./numOfSines*np.sin(2*np.pi*f_t*t+phasArray[i])+12.5/numOfSines
                i=i+1
                # print p1
            # p1=2.5*np.sin(2*np.pi*f_t*t)+3.5
            if p1 <=1.0:
                p1 =1.0
            if p1>=25.0:
                p1=25.0
            pd_array=np.array([p1,1.0,1.0])
            self.send_zipped_socket0(pd_array)
            # print 
            sleep(0.005)
            
    def send_zipped_socket0(self, obj, flags=0, protocol=-1):
        """pack and compress an object with pickle and zlib."""
        pobj = pickle.dumps(obj, protocol)
        zobj = zlib.compress(pobj)
        self.socket0.send(zobj, flags=flags)

    def send_zipped_socket1(self, obj, flags=0, protocol=-1):
        """pack and compress an object with pickle and zlib."""
        pobj = pickle.dumps(obj, protocol)
        zobj = zlib.compress(pobj)
        self.socket1.send(zobj, flags=flags)

    def recv_zipped_socket2(self,flags=0):
        """reconstruct a Python object sent with zipped_pickle"""
        zobj = self.socket2.recv(flags)
        pobj = zlib.decompress(zobj)
        return pickle.loads(pobj)

    def recv_zipped_socket3(self,flags=0):
        """reconstruct a Python object sent with zipped_pickle"""
        zobj = self.socket3.recv(flags)
        pobj = zlib.decompress(zobj)
        return pickle.loads(pobj)

    def recv_cpp_socket2(self):
        strMsg =self.socket2.recv()
        # floatArray=np.fromstring(strMsg)
        return np.fromstring(strMsg, dtype=float, sep=' ')

def main():
    try:
        p_client=pc_client()
        p_client.th1.start()
        sleep(0.5)
        p_client.th2.start()
        while 1:
            pass
    except KeyboardInterrupt:
        p_client.th1_flag=False
        p_client.th2_flag=False
        exit()

if __name__ == '__main__':
    main()
