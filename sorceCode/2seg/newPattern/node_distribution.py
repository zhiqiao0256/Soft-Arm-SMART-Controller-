"""
gather xyz, rot matrix 
calculate phi theta for each segment
publish calcualted data to local network for each segment to sub
pushlish data to collection node

"""
import numpy as np
import zmq
import pickle
import zlib
from time import time, sleep
import threading
# import math
class allocate_mocapAndtheta(object):
    """docstring for pc_client"""
    def __init__(self):
        """ Select use mocap or not"""
        self.flag_use_mocap=1
        """ Initiate ZMQ communication"""
        context = zmq.Context()
        self.socket1 = context.socket(zmq.PUB)
        self.socket1.setsockopt(zmq.CONFLATE,True)
        self.socket1.bind("tcp://127.0.0.1:6666") ## PUB xyz theta phi for seg1

        self.socket2 = context.socket(zmq.PUB)
        self.socket2.setsockopt(zmq.CONFLATE,True)
        self.socket2.bind("tcp://127.0.0.1:7666") ## PUB xyz theta phi for seg2

        self.socket3 = context.socket(zmq.PUB)
        self.socket3.setsockopt(zmq.CONFLATE,True)
        self.socket3.bind("tcp://127.0.0.1:7666") ## PUB xyz theta phi for seg3

        self.socket0 = context.socket(zmq.PUB)##PUb to collection
        self.socket0.setsockopt(zmq.CONFLATE,True)
        self.socket0.bind("tcp://127.0.0.1:8888")

        self.socket00=context.socket(zmq.SUB) ### sub mocap data
        self.socket00.setsockopt(zmq.SUBSCRIBE,'')
        self.socket00.setsockopt(zmq.CONFLATE,True)

        if self.flag_use_mocap == True:
            self.socket00.connect("tcp://127.0.0.1:3885")
            print "Connected to mocap"

        """ Format recording """
        self.array3setswithrotation=np.array([0.]*21)# base(x y z qw qx qy qz) top(x1 y1 z1 qw1 qx1 qy1 qz1)
        self.state_variable_array=np.array([0.0]*4)# theta1, phi1, theta2, phi2

        """State variable Ini """
        self.x1_old=0.0#theta1 rad
        self.x1_t0=0.0 #theta1 rad
        self.x1_current=0.0
        self.x2_current=0.0 # phi1 rad
        self.x3_old=0.0# theta2 rad
        self.x3_t0=0.0#  rad
        self.x3_current=0.0
        self.x4_current=0.0 # phi2 rad/s
        self.t0=0.0 # timer sec
        self.t_old=0.0 #timer sec
        self.t_new=0.0
        self.loop_timer=time()

    def cal_state_var(self):
        try:
            while 1:
                self.array3setswithrotation=self.recv_cpp_socket00()
                vector_phiTheta=np.array([0.]*4)
                vector_phiTheta=self.getThetaPhiAndr0FromXYZ()
                self.x1_current=vector_phiTheta[0]
                self.x2_current=vector_phiTheta[1]
                self.x3_current=vector_phiTheta[2]
                self.x4_current=vector_phiTheta[3]
    def th_pub_raspi_client_pd(self):
        try:
            if self.flag_reset==1:
                self.loop_timer=time()# reset loop timer
                self.step_response(np.array([1.0]*4),10)
                self.flag_reset=0
            if self.flag_use_mocap == True:
                self.array3setswithrotation=self.recv_cpp_socket2()
                print("mocap connected")
            vector_phiTheta=np.array([0.]*4)
            vector_phiTheta=self.getThetaPhiAndr0FromXYZ()

            self.x1_current=vector_phiTheta[0]
            self.x2_current=vector_phiTheta[1]
            self.x3_current=vector_phiTheta[2]
            self.x4_current=vector_phiTheta[3]
            self.t0=time()
            self.t_old=time()
            for index_num in range(1,30,5):
               self.loop_timer=time()
               # p123=np.random.randint(40, size=3)
               p1234=np.array([index_num,index_num,1.0,1.0])
               self.openloopStepPressureCtrl(p1234,10)
            self.loop_timer=time()# reset loop timer               
            self.step_response(np.array([0.0]*4),5)
            self.th1_flag=False
            self.th2_flag=False
            exit()
        except KeyboardInterrupt:
            self.th1_flag=False
            self.th2_flag=False
            exit()
            print "Press Ctrl+C to Stop"
        #     print "Press Ctrl+C to Stop"
            
    def th_sub_pub_mocap(self):# thread config of read data from mocap and send packed msg to record file.
        try:
            while self.run_event.is_set() and self.th2_flag:
                if self.flag_use_mocap == True:
                    self.array3setswithrotation=self.recv_cpp_socket00()
                self.pd_pm_array=self.recv_zipped_socket3()
                self.array3setsRecord=np.concatenate((self.pd_pm_array, self.array3setswithrotation, self.state_variable_array), axis=None)
                if self.flag_reset==0:
                    self.send_zipped_socket1(self.array3setsRecord)
                    print round(self.t_new,2),self.pd_pm_array
                # sleep(0.005)
            exit()
        except KeyboardInterrupt:
            self.th1_flag=False
            self.th2_flag=False
            exit()

    def getThetaPhiAndr0FromXYZ(self):
        #Fix 08-12-2021 Cam Stream is Z-up
        #Fix 08-12-2021 Phi is calculated from -pi to pi
        phi_rad=0.0
        phi_rad1=0.0
        theta_rad=0.0
        theta_rad1=0.0
        # get raw top(x,y,z) bottom (x,y,z) top1(x,y,z) 
        vector_base=np.array([0., 0., 0.])
        vector_top=np.array([0., 0., 0.])
        vector_base1=vector_top
        vector_top1=np.array([0., 0., 0.])
        # adjust top frame w/ local base frame
        vector_base=self.array3setswithrotation[0:3]# base(x,y,z)
        vector_base1=self.array3setswithrotation[7:10]
        vector_top=self.array3setswithrotation[7:10]-vector_base# top(x,y,z)-base(x,y,z)
        vector_top1=self.array3setswithrotation[14:17]-vector_base1
        # print"v_tip",vector_top
        # Rotate to algorithm frame Rz with -90 deg  Rx=([1.0, 0.0, 0.0],[0.0, 0.0, 1.0],[0.0, -1.0, 0.0])
        tip_camFrame=np.array([0., 0., 0.])
        tip_camFrame[0]=vector_top[0] # baseFrame x
        tip_camFrame[1]=vector_top[1] #baseFrame  y
        tip_camFrame[2]=vector_top[2] # baseFrame z
        # print(self.array3setswithrotation)
        # Calculate phi rad in [-pi,pi]
        # phi_rad=0.
        if np.absolute(tip_camFrame[0])<0.0001:
            phi_rad=np.pi/2.0
        else:
            phi_rad=np.arctan(tip_camFrame[1]/tip_camFrame[0])

        #Calculate theta rad using xyz
        theta_rad = 2.0*np.sign(tip_camFrame[2])*np.arccos(tip_camFrame[2]/np.sqrt(tip_camFrame[0]*tip_camFrame[0] + tip_camFrame[1]*tip_camFrame[1] + tip_camFrame[2]*tip_camFrame[2]))      
        tip_camFrame1=np.array([0., 0., 0.])
        tip_camFrame1[0]=vector_top1[0]
        tip_camFrame1[1]=vector_top1[1]
        tip_camFrame1[2]=vector_top1[2]

        if np.absolute(tip_camFrame1[0])<0.0001:
            phi_rad1=np.pi/2.0
        else:
            phi_rad1=np.arctan(tip_camFrame1[1]/tip_camFrame1[0])
        theta_rad1 = 2.0*np.sign(tip_camFrame1[2])*np.arccos(tip_camFrame1[2]/np.sqrt(tip_camFrame1[0]*tip_camFrame1[0] + tip_camFrame1[1]*tip_camFrame1[1] + tip_camFrame1[2]*tip_camFrame1[2]))      
        # tip_camFrame1=np.array([0., 0., 0.])
        return np.array([phi_rad,theta_rad,phi_rad1,theta_rad1])

    def getr0fromPhi(self,tip_camFrame,phi_rad):
        # par_set.trianlge_length/sqrt(3)*cos(pi/3)./cos(mod((trainSet.phi_rad)+p1_offset,2*pi/3)-pi/3);
        r0=self.l_tri/np.sqrt(3)*np.cos(np.pi/3)/np.cos(np.remainder(phi_rad+self.p1_off_set_angle,2*np.pi/3) - np.pi/3)
        return r0
            
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

    def send_zipped_socket2(self, obj, flags=0, protocol=-1):
        """pack and compress an object with pickle and zlib."""
        pobj = pickle.dumps(obj, protocol)
        zobj = zlib.compress(pobj)
        self.socket0.send(zobj, flags=flags)

    def send_zipped_socket3(self, obj, flags=0, protocol=-1):
        """pack and compress an object with pickle and zlib."""
        pobj = pickle.dumps(obj, protocol)
        zobj = zlib.compress(pobj)
        self.socket1.send(zobj, flags=flags)

    def recv_zipped_socket00(self,flags=0):
        """reconstruct a Python object sent with zipped_pickle"""
        zobj = self.socket00.recv(flags)
        pobj = zlib.decompress(zobj)
        return pickle.loads(pobj)


    def recv_cpp_socket00(self):
        strMsg =self.socket2.recv()
        # floatArray=np.fromstring(strMsg)
        return np.fromstring(strMsg, dtype=float, sep=' ')

