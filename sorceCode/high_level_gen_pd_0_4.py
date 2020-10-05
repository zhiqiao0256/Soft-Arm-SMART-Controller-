"""
This code is the PC Client

"""
import numpy as np
import zmq
import pickle
import zlib
from time import time, sleep
import threading
# import math
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
        self.array2setswithrotation=np.array([0.]*14)# base(x y z qw qx qy qz) top(x1 y1 z1 qw1 qx1 qy1 qz1)
        self.array2setsRecord=np.array([0.]*39)#t pd1 pd2 pd3 + pm1 +pm2 +pm3 + positon +orintation

        """ Thearding Setup """
        self.th1_flag=True
        self.th2_flag=True
        self.run_event=threading.Event()
        self.run_event.set()
        self.th1=threading.Thread(name='raspi_client',target=self.th_pub_raspi_client_pd)
        self.th2=threading.Thread(name='mocap',target=self.th_sub_pub_mocap)

        """Initialize SMC Parameter """
        # Actuator geometic parameters
        self.m0=0.35# segment weight kg
        self.g=9.8  # gravity m/s^2
        self.L=0.185# segment length m
        self.triangleEdgeLength= 0.07 # m
        self.actuatorWidth= 0.015 # m
    	self.R_f= np.sqrt(3.0)/6*self.triangleEdgeLength+self.actuatorWidth= 0.015 # distribution radius of force
    	self.offsetAngle_p1=np.radians(150) # deg2rad(150)
    	self.edge_pt1=np.array([self.R_f*np.cos(self.offsetAngle_p1-np.pi/3), self.R_f*np.sin(self.offsetAngle_p1-np.pi/3), 0.])
    	self.edge_pt2=np.array([self.R_f*np.cos(self.offsetAngle_p1+np.pi/3), self.R_f*np.sin(self.offsetAngle_p1+np.pi/3), 0.])
    	self.edge_pt3=np.array([self.R_f*np.cos(self.offsetAngle_p1-np.pi), self.R_f*np.sin(self.offsetAngle_p1-np.pi), 0.])
    	self.r0=0.
    	# SMC state variable and time stamps
    	self.x1_old=0. # state for last iteration
    	self.x2_old=0. # state for last iteration
    	self.x1_current=0. # state for current iteration
    	self.x2_current=0. # state for current iteration
    	self.xd1=0.
    	self.x1_error_old=0.   # error for last iteration
    	self.x1_error_current=0.   # error for current iteration
    	self.x1_dot_error=0. # error derivative for current iteration
    	self.t0=time()
    	self.t_old=0.
    	self.t_new=0.
    	# Input sine wave parameters
    	self.Amp=np.radians(10)
    	self.Boff=np.radians(-40)
    	self.Freq=0.1 # Hz
    	# SMC model uncertainty
    	self.alpha0=0. # scaler of torque
    	self.k0=0. # Nm/rad
    	self.b0=0. # Nm/(rad/s)
    	self.delta_k_max=0. # bonded uncertainty for k
    	self.detla_b_max=0. # bonded uncertainty for b
    	self.input_pressure_limit_psi= 25. # input limit of pressure psi
    	# SMC control gain selection
    	self.smc_lambda=10. # sliding surface gain
    	self.smc_eta=10. # reaching speed of sliding surface

    def th_pub_raspi_client_pd(self):
        try:
        	self.step_response(np.array([1.0,1.0,1.0]),5)
        	self.t0=time()
        	self.t_old=time()-self.t0
        	vector_phiTheta=np.array([0., 0.])
        	vector_phiTheta=self.getThetaPhiAndR0FromXYZ()
			self.x1_old=vector_phiTheta[1]
			self.xd1=-self.Amp*np.sin(2*np.pi*self.Freq*self.t_old)+self.Boff
			self.x1_error_old=self.xd1-self.x1_old
        	while self.run_event.is_set() and self.th1_flag:
        		if self.t_old<=60.0:
        			self.calculateControlInput()
        		else:
            		self.th1_flag=False
            		self.th2_flag=False
            self.step_response(np.array([1.0,1.0,1.0]),5)
        except KeyboardInterrupt:
            self.th1_flag=False
            self.th2_flag=False
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
        	self.th1_flag=False
            self.th2_flag=False

	def getThetaPhiAndr0FromXYZ(self):
		# get raw top(x,y,z) bottom (x,y,z)
		vector_base=np.array([0., 0., 0.])
		vector_top=np.array([0., 0., 0.])
		vector_base=self.array2setswithrotation[0:3]# base(x,y,z)
		vector_top=self.array2setswithrotation[7:10]-vector_base# top(x,y,z)-base(x,y,z)

		# Rotate to algorithm frame Rz with -90 deg  Rx=([1.0, 0.0, 0.0],[0.0, 0.0, 1.0],[0.0, -1.0, 0.0])
		tip_camFrame=np.array([0., 0., 0.])
		tip_camFrame[0]=vector_top[0] # camFrame x
		tip_camFrame[1]=-vector_top[2] #camFram -z
		tip_camFrame[2]=vector_top[1] # camFrame y

		# calculate phi rad (0, 2pi)
		phi_rad=0.
		if tip_camFrame[0] > 0.:
			phi_rad=np.atan(tip_camFrame[1]/tip_camFrame[0])
		elif tip_camFrame[0] == 0. and tip_camFrame[1] > 0.:
			phi_rad=np.pi/2
		elif tip_camFrame[0] == 0. and tip_camFrame[1] < 0.:
			phi_rad=-np.pi/2
		elif tip_camFrame[0] == 0. and tip_camFrame[1] == 0.:
			phi_rad=0.
		elif tip_camFrame[0] < 0. and tip_camFrame[1] >= 0.:
			phi_rad=np.pi + np.atan(tip_camFrame[1]/tip_camFrame[0])
		elif tip_camFrame[0] < 0. and tip_camFrame[1] < 0.:
			phi_rad=-np.pi + np.atan(tip_camFrame[1]/tip_camFrame[0])
		if phi_rad <0.:
			phi_rad=phi_rad+2.0*np.pi
		# calculate r0
		self.r0=self.getr0fromPhi(tip_camFrame,phi_rad)

		# Rotate from CamFrame to BaseFrame with Rz(phi) and Rz2=[1 0 0;0 0 -1; 0 1 0]
		cphi= np.cos(phi_rad)
		sphi= np.sin(phi_rad)
		tip_baseFrame=np.array([0., 0., 0.])
		tip_baseFrame[0]=cphi*tip_camFrame[0]+sphi*tip_camFrame[1] # x_new=c*x + s*y
		tip_baseFrame[1]=tip_camFrame[2]# y_new= z
		tip_baseFrame[2]=sphi*tip_camFrame[0]-cphi*tip_camFrame[1] # z_new= s*x -c*y

		# calculate theta rad theta=2*sign(x)*asin(norm(x)/sqrt(x^2+y^2))
		theta_rad=(2.0*-np.sign(1.0,tip_baseFrame[0])*
					np.asin(np.absolute(tip_baseFrame[0])/np.sqrt((tip_baseFrame[0])^2+(tip_baseFrame[1])^2)))
		return np.array([phi_rad,theta_rad])

    def getr0fromPhi(self,tip_camFrame,phi_rad):
		# calculate intersection point on each edge
		beta_array=np.array([0., 0., 0.])
		beta_array[0]=((self.edge_pt1[0]*self.edge_pt2[1]-self.edge_pt2[0]*self.edge_pt1[1])/
						(tip_camFrame[0]*(self.edge_pt2[1]-self.edge_pt1[1])-tip_camFrame[1]*(self.edge_pt2[0]-self.edge_pt1[0])));
		beta_array[1]=((self.edge_pt1[0]*self.edge_pt3[1]-self.edge_pt3[0]*self.edge_pt1[1])/
						(tip_camFrame[0]*(self.edge_pt3[1]-self.edge_pt1[1])-tip_camFrame[1]*(self.edge_pt3[0]-self.edge_pt1[0])));
		beta_array[2]=((self.edge_pt3[0]*self.edge_pt2[1]-self.edge_pt2[0]*self.edge_pt3[1])/
						(tip_camFrame[0]*(self.edge_pt2[1]-self.edge_pt3[1])-tip_camFrame[1]*(self.edge_pt2[0]-self.edge_pt3[0])));

		# calculate r0 in base frame
		r_beta_array=np.array([0.,0.,0.])
		r0=0.
		for index_i in range(3): # find r_i= norm(beta_i*xt,beta_i*yt)
			r_beta_array[index_i]= np.sqrt((beta_array[index_i])^2*((tip_camFrame[0])^2+(tip_camFrame[1])^2))
			if r_beta_array[index_i] <= self.triangleEdgeLength/np.sqrt(3.0):
				r0_x=(beta_array[index_i])*(tip_camFrame[0])
				r0_y=(beta_array[index_i])*(tip_camFrame[1])
				cphi= np.cos(phi_rad)
				sphi= np.sin(phi_rad)
				r0=cphi*r0_x+sphi*r0_y
		return r0

	def calculateControlInput(self):
		# variable ini.
		vector_phiTheta=np.array([0., 0.])
		phi=0.
		theta=0.
		dtheta=0.
		pm1_MPa=0.
		pm2_MPa=0.
		pm3_MPa=0.
		uMax=0.
		s=0.
		Izz=0.
		M=0.
		C=0.
		G=0.
		f=0.
		uAlpha=0.
		ddxd1=0.
		pd_array=np.array([0.,0.,0.])
		uMin=0.
		# Update pm1, pm2, pm3, theta, r0, uMax, Ddot(error)
		vector_phiTheta=self.getThetaPhiAndr0FromXYZ()
		phi=vector_phiTheta[0]
		theta=vector_phiTheta[1]
		pm1_MPa=self.pd_pm_array[3]*0.00689476
		pm2_MPa=self.pd_pm_array[4]*0.00689476
		pm3_MPa=self.pd_pm_array[5]*0.00689476
		uMax=(np.absolute(self.alpha0 * (np.sin(phi) * (0.5*self.input_pressure_limit_psi*0.00689476 + 0.5*pm2_MPa - pm3_MPa)
			-np.sqrt(3.0) * np.cos(phi) * (0.5*self.input_pressure_limit_psi*0.00689476 - 0.5*pm2_MPa)))
		)
		#Update State variables x1,x2, x1 error,
		self.t_new=time()-self.t0
		self.x1_current=theta
		self.xd1=-self.Amp*np.sin(2*np.pi*self.Freq*self.t_new)+self.Boff
		self.x1_error_current=self.xd1-self.x1_current
		self.x2_current=(self.x1_current-self.x1_old)/(self.t_new-self.t_old)
		dtheta=self.x2_current
		self.x1_dot_error=(self.x1_error_current-self.x1_error_old)/(self.t_new-self.t_old)
		# Update SMC 
		s=self.smc_lambda*self.x1_error_current+self.x1_dot_error
		# Update M,C,G
		Izz=self.m0*self.r0^2
		if theta==0.:
			M=self.m0*(self.L/2)^2
			C=0.
			G=-self.g*self.m0
		else:
			M=(Izz/4 + self.m0*((np.cos(theta/2)*(self.r0 - self.L/theta))/2 +
        		(self.L*np.sin(theta/2))/theta^2)^2 + (self.m0*np.sin(theta/2)^2*(self.r0 - self.L/theta)^2)/4
			)
		    C=(-(self.L*dtheta*self.m0*(2*np.sin(theta/2) - theta*np.cos(theta/2))*(2*self.L*np.sin(theta/2)
        		- self.L*theta*np.cos(theta/2) + self.r0*theta^2*np.cos(theta/2)))/(2*theta^5)
		    )
		    G=(-(self.g*self.m0*(self.L*np.sin(theta) + self.r0*theta^2*np.cos(theta) - self.L*theta*np.cos(theta)))/(2*theta^2)
		    )
		# Updata f(x1,x2)
		f=(1.0/M) * (-self.k0* self.x1_current- (self.b0+C)* self.x2_current- G)
		# Update uAlpha
		ddxd1=self.Amp*(2*np.pi*self.Freq)^2*np.sin(2*np.pi*self.Freq*self.t_new)
		uAlpha=(M*(self.smc_lambda*self.x1_dot_error+ ddxd1 - f + self.smc_eta* np.sign(s)
					+np.sign(s)*(self.delta_k_max*np.absolute(self.x1_current/M) + self.delta_b_max*np.absolute(self.x2_current/M)))
				)
		# Constrain uMin<=uAlpha<= uMax
		if uAlpha >= uMax:
			pd_array=np.array([25.0,1.0,1.0])
		elif uAlpha <=uMin:
			pd_array=np.array([1.0,1.0,1.0])
		else:
			cphi= np.cos(phi)
			sphi= np.sin(phi)
			p1=0.
			if 0.5*sphi-0.5*np.sqrt(3)*cphi == 0:
				pd_array=np.array([1.0,1.0,1.0])
			else:
				p1=(uAlpha/self.alpha0-(0.5*sphi+0.5*np.sqrt(3)*cphi)*pm2_MPa+sphi*pm3_MPa)/(0.5*sphi-0.5*np.sqrt(3)*cphi)
				pd_array=np.array([p1,1.0,1.0])		
		# Iterate x1, x1 error and time stamp
		self.x1_old=self.x1_current
		self.x1_error_old=self.x1_error_current
		self.t_old=self.t_new
		self.send_zipped_socket0(pd_array)

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
