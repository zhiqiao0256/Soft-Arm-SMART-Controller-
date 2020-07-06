"""
This code is the PC Client

"""
import numpy as np
import zmq
import pickle
import zlib
from time import time, sleep
import threading
class pc_client(object):
    """docstring for pc_client"""
    def __init__(self):
        context = zmq.Context()
        self.socket0 = context.socket(zmq.PUB)
        self.socket0.setsockopt(zmq.CONFLATE,True)
        self.socket0.bind("tcp://127.0.0.1:4444")## PUB pd to Raspi Client

        self.socket1 = context.socket(zmq.PUB)##PUb to Record
        self.socket1.setsockopt(zmq.CONFLATE,True)
        self.socket1.bind("tcp://127.0.0.1:5555")

        self.socket2=context.socket(zmq.SUB) ### sub mocap data
        self.socket2.setsockopt(zmq.SUBSCRIBE,'')
        self.socket2.setsockopt(zmq.CONFLATE,True)
        self.socket2.setsockopt(zmq.RCVTIMEO,10000)
        self.socket2.connect("tcp://10.203.49.120:8000")

        self.socket3=context.socket(zmq.SUB) ### sub Raspi Client
        self.socket3.setsockopt(zmq.SUBSCRIBE,'')
        self.socket3.setsockopt(zmq.CONFLATE,True)
        self.socket3.setsockopt(zmq.RCVTIMEO,10000)
        self.socket3.connect("tcp://127.0.0.1:3333")

        self.array2setswithrotation=np.array([0.]*14)# x y z qw qx qy qz x1 y1 z1 qw1 qx1 qy1 qz1
        self.array2setsRecord=np.array([0.]*39)#t pd1 pd2 pd3 + pm1 +pm2 +pm3 + positon +orintation

        self.th1_flag=True
        self.th2_flag=True
        self.run_event=threading.Event()
        self.run_event.set()
        self.th1=threading.Thread(name='raspi_client',target=self.th_pub_raspi_client_pd)
        self.th2=threading.Thread(name='mocap',target=self.th_sub_pub_mocap)
        #
        self.pd_pm_array=np.array([0.]*6)

    def th_pub_raspi_client_pd(self):
            while self.run_event.is_set() and self.th1_flag:
                try:
                    self.step_response(np.array([5.0]*3),5)
                    raw_input("Press Enter to Start")
                except KeyboardInterrupt:
                    self.th1_flag=False
            print "Press Ctrl+C to Stop"
            
    def th_sub_pub_mocap(self):
        try:
            while self.run_event.is_set() and self.th2_flag:
                self.array2setswithrotation=self.recv_zipped_socket2()
                self.pd_pm_array=self.recv_zipped_socket3()
                self.array2setsRecord=np.concatenate((self.pd_pm_array, self.array2setswithrotation), axis=None)
                self.send_zipped_socket1(self.array2setsRecord)
        except KeyboardInterrupt:
            self.th2_flag=False
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

    def sine_response(self,A_array,freq_array,B_array,sine_time):
        for i in range(int(sine_time/0.005)):
            if self.th1_flag:
                pd_array=A_array*np.cos(2.0*np.pi*freq_array*0.005*i)+B_array
                self.send_zipped_socket0(pd_array)

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
    def end_threads(self):
        print"Trying to Stop"
        self.th1_flag=False
        self.th2_flag=False
        self.run_event.clear()
        self.th1.join()
        self.th2.join()
        print"Threads Stopped"
        pd_array=np.array([1.]*3)
        self.send_zipped_socket0(pd_array)
        sleep(5)
        p_client.socket0.close()
        p_client.socket1.close()
        p_client.socket2.close()
        print("Loop Done")
        exit()
def main():
    try:
        p_client=pc_client()
        p_client.th1.start()
        sleep(0.5)
        p_client.th2.start()
        while 1:
            pass
    except KeyboardInterrupt:
        print"Trying to Stop"
        p_client.th1_flag=False
        p_client.th2_flag=False
        p_client.run_event.clear()
        p_client.th1.join()
        p_client.th2.join()
        print"Threads Stopped"
        pd_array=np.array([0.]*3)
        p_client.send_zipped_socket0(pd_array)
        sleep(5)
        p_client.socket0.close()
        p_client.socket1.close()
        p_client.socket2.close()
        print("Loop Done")
        exit()

if __name__ == '__main__':
    main()