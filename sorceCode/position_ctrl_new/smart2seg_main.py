"""
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
        self.flag_use_mocap = 1
        self.flag_pos_profile = 0
        # Actuator geometic parameters
        self.m0 = 0.35  # segment weight kg
        self.g = 9.8  # gravity m/s**2
        self.L = 0.185  # segment length m
        self.actuatorWidth = 0.015  # m
        self.R_f = np.sqrt(3.0) / 6 * self.triangleEdgeLength + self.actuatorWidth  # distribution radius of force
        self.p1_off_set_angle = np.deg2rad(150.0)  # deg
        self.l_tri = 0.07  # m
        self.alpha0 = 1.1055  # scaler of torque
        self.k0 = 0.4413  # Nm/rad
        self.b0 = 0.7535  # Nm/(rad/s)
        """ Initiate ZMQ communication"""
        context = zmq.Context()
        self.socket0 = context.socket(zmq.PUB)
        self.socket0.setsockopt(zmq.CONFLATE, True)
        self.socket0.bind("tcp://10.203.53.226:4444")  ## PUB pd to Raspi Client

        self.socket1 = context.socket(zmq.PUB)  ##PUb to Record
        self.socket1.setsockopt(zmq.CONFLATE, True)
        self.socket1.bind("tcp://127.0.0.1:5555")

        self.socket2 = context.socket(zmq.SUB)  ### sub mocap data
        self.socket2.setsockopt(zmq.SUBSCRIBE, '')
        self.socket2.setsockopt(zmq.CONFLATE, True)

        if self.flag_use_mocap == True:
            self.socket2.connect("tcp://127.0.0.1:3885")
            print("Connected to mocap")

        self.socket3 = context.socket(zmq.SUB)  ### sub Raspi Client
        self.socket3.setsockopt(zmq.SUBSCRIBE, '')
        self.socket3.setsockopt(zmq.CONFLATE, True)
        # self.socket3.setsockopt(zmq.RCVTIMEO,10000)
        self.socket3.connect("tcp://10.203.54.75:3333")
        print("Connected to Low")

        """ Format recording """
        self.array3setsRecord = np.array([0.] * 41)  # t pd1 pd2 pd3 + pm1 +pm2 +pm3 + positon +orintation
        self.pd_pm_array = np.array([0.] * 8)  # pd1 pd2 pd3 pd4 + pm1 +pm2 +pm3 pm4(psi)
        self.array3setswithrotation = np.array([0.] * 14)  # base(x y z qw qx qy qz) top(x1 y1 z1 qw1 qx1 qy1 qz1)
        """ Thearding Setup """
        self.th1_flag = True
        self.th2_flag = True
        self.run_event = threading.Event()
        self.run_event.set()
        self.th1 = threading.Thread(name='raspi_client', target=self.th_pub_raspi_client_pd)
        self.th2 = threading.Thread(name='mocap', target=self.th_sub_pub_mocap)
        """State Variables """
        self.t_old = 0.0  # sec
        self.state_var_old = np.array([0.0] * 2)  # theta theta1 rad
        self.state_var_current = np.array([0.0] * 2)  # theta theta1 rad
        self.state_var_deri = np.array([0.0] * 2)
        self.state_error_current = np.array([0.0] * 2)
        self.state_error_old = np.array([0.0] * 2)
        self.state_error_deri = np.array([0.0] * 2)
        self.vector_xdc = np.array([0.0]*2)
        self.vector_phi = np.array([0.0]*2)
        """Input Parameters"""
        """ Position Ramp"""
        self.flag_ramp_phase = 0  #
        self.rampAmpAbs = 10  # deg
        self.rampRateAbs = 2  # deg/s
        self.rampFlatTime = 5  # sec
        """ SMART Conctroller"""
        self.num_of_seg = 2
        self.flag_stage = np.array([0]*self.num_of_seg)
        self.smcNDOB_lambda = np.array([1.0]*self.num_of_seg)
        self.smcNDOB_k_sig =np.array([1.0]*self.num_of_seg)
        self.smcNDOB_eta = np.array([1.0]*self.num_of_seg)
        self.smcNDOB_kp_sig = np.array([5.0]*self.num_of_seg)
        self.smcNDOB_z_current = np.array([0]*self.num_of_seg)
        self.smcNDOB_z_current_inner = np.array([0]*self.num_of_seg)
        self.smcNDOB_z_old = np.array([0]*self.num_of_seg)
        self.smcNDOB_z_old_inner = np.array([0]*self.num_of_seg)
        self.smcNDOB_dz = np.array([0]*self.num_of_seg)
        self.smcNDOB_dz_inner = np.array([0]*self.num_of_seg)
        self.vector_xdc = np.array([0.0]*self.num_of_seg)
        self.vector_dxdc = np.array([0.0] * self.num_of_seg)
        self.vector_ddxdc = np.array([0.0] * self.num_of_seg)
        self.m_switch_pos_th = 0.1  # rad
        self.m_switch_tqr_th = 0.4  # Nm
        self.flag_1st_contact = np.array([1.0]*self.num_of_seg)

    def th_pub_raspi_client_pd(self):
        try:
            # local variable ini
            self.t_old = time()
            self.t_start = time()
            vector_phiTheta = np.array([0.] * 4)  # phi theta phi1 theta1
            vector_r0 = np.array([0.] * 2)
            vector_d_Theta = np.array([0.] * 2)
            vector_MCG_0 = np.array([0.] * 3)
            vector_MCG_1 = np.array([0.] * 3)
            ############################
            ###### get 1st phi, theta, t0, r0
            if self.flag_reset == 1:
                self.step_response(np.array([0.0] * 4), 5, time())
                self.flag_reset = 0
            if self.flag_use_mocap == True:
                self.array3setswithrotation = self.recv_cpp_socket2()
            # update phi, theta, and r0
            vector_phiTheta = self.getThetaPhiFromXYZ()
            vector_r0[0] = self.getr0fromPhi(vector_phiTheta[0])
            vector_r0[1] = self.getr0fromPhi(vector_phiTheta[2])
            self.state_var_old[0] = vector_phiTheta[1]
            self.state_var_old[1] = vector_phiTheta[3]
            #########################################
            #### calcualte control input
            while self.th1_flag == True and self.th2_flag == True:
                #### Update State var ####
                if self.flag_use_mocap == True:
                    self.array3setswithrotation = self.recv_cpp_socket2()
                # update phi, theta, and r0
                vector_phiTheta = self.getThetaPhiFromXYZ()
                vector_r0[0] = self.getr0fromPhi(vector_phiTheta[0])
                vector_r0[1] = self.getr0fromPhi(vector_phiTheta[2])
                self.state_var_current[0] = vector_phiTheta[1]
                self.state_var_current[1] = vector_phiTheta[3]
                self.vector_phi[0] = vector_phiTheta[0]
                self.vector_phi[1] = vector_phiTheta[2]
                if time() - self.t_old < 0.0001:
                    self.state_var_deri = np.array([0.0] * 2)
                else:
                    self.state_var_deri = (self.state_var_current - self.state_var_old) / (time() - self.t_old)
                # update M, C, G terms
                vector_MCG_0 = self.getMCGfromR0andTheta(self.state_var_current[0], vector_r0[0])
                vector_MCG_1 = self.getMCGfromR0andTheta(self.state_var_current[1], vector_r0[1])
                # update original desired position and its deri,doulbe deri
                if self.flag_pos_profile == 0:
                    vector_xd_0 = self.positionRampFromT0(time() - self.t_start, np.deg2rad(-5))
                    vector_xd_1 = self.positionRampFromT0(time() - self.t_start, np.deg2rad(-5))
                # update tracking errors
                self.state_error_current = self.state_var_current - np.array([vector_xd_0[0], vector_xd_1[0]])
                if time() - self.t_old < 0.0001:
                    self.state_error_deri = np.array([0.0] * 2)
                else:
                    self.state_error_deri = (self.state_error_current - self.state_error_old) / (time() - self.t_old)
                ################ smart control ########################
                dt=time() - self.t_old
                pd_array=np.array([0.0]*4)
                pd_array[0] = self.smart(0,vector_MCG_0, vector_xd_0, dt)
                pd_array[2] = self.smart(1, vector_MCG_1, vector_xd_1, dt)
                self.t_old=time()
                self.state_var_old=self.state_var_current
                self.state_error_old=self.state_error_current
                self.send_zipped_socket0(pd_array)
        except KeyboardInterrupt:
            self.th1_flag = False
            self.th2_flag = False
            print("Press Ctrl+C to Stop")
        #     print "Press Ctrl+C to Stop"

    def th_sub_pub_mocap(self):  # thread config of read data from mocap and send packed msg to record file.
        try:
            while self.run_event.is_set() and self.th2_flag:
                if self.flag_use_mocap == True:
                    self.array3setswithrotation = self.recv_cpp_socket2()
                self.pd_pm_array = self.recv_zipped_socket3()
                self.smcNDOB_tracking = np.array(
                    [self.smcNDOB_p1, self.smcNDOB_u_total, self.smcNDOB_u_eq, self.smcNDOB_u_s, self.smcNDOB_u_n,
                     self.smcNDOB_dist_est_tqr, self.xd_new, self.flag_stage, self.smcNDOB_dist_est_inner_tqr])
                self.array3setsRecord = np.concatenate(
                    (self.pd_pm_array, self.array3setswithrotation, self.state_var_current, self.state_var_deri,
                     self.state_error_deri),
                    axis=None)
                if self.flag_reset == 0:
                    self.send_zipped_socket1(self.array3setsRecord)
                # sleep(0.005)
            exit()
        except KeyboardInterrupt:
            exit()
            self.th1_flag = False
            self.th2_flag = False

    def getThetaPhiFromXYZ(self):
        # Fix 08-12-2021 Cam Stream is Z-up
        # Fix 08-12-2021 Phi is calculated from -pi to pi
        phi_rad = 0.0
        phi_rad1 = 0.0
        theta_rad = 0.0
        theta_rad1 = 0.0
        # get raw top(x,y,z) bottom (x,y,z) top1(x,y,z) 
        vector_base = np.array([0., 0., 0.])
        vector_top = np.array([0., 0., 0.])
        vector_base1 = vector_top
        vector_top1 = np.array([0., 0., 0.])
        # adjust top frame w/ local base frame
        vector_base = self.array3setswithrotation[0:3]  # base(x,y,z)
        vector_base1 = self.array3setswithrotation[7:10]
        vector_top = self.array3setswithrotation[7:10]  # top(x,y,z)-base(x,y,z)
        vector_top1 = self.array3setswithrotation[14:17]
        # print"v_tip",vector_top
        # Rotate to algorithm frame Rz with -90 deg  Rx=([1.0, 0.0, 0.0],[0.0, 0.0, 1.0],[0.0, -1.0, 0.0])
        tip_camFrame = np.array([0., 0., 0.])
        tip_camFrame[0] = vector_top[0] - vector_base[0]  # baseFrame x
        tip_camFrame[1] = vector_top[1] - vector_base[1]  # baseFrame  y
        tip_camFrame[2] = vector_top[2] - vector_base[2]  # baseFrame z
        # print(self.array3setswithrotation)
        # Calculate phi rad in [-pi,pi]
        # phi_rad=0.
        if np.absolute(tip_camFrame[0]) < 0.0001:
            phi_rad = np.pi / 2.0
        else:
            phi_rad = np.arctan(tip_camFrame[1] / tip_camFrame[0])

        # Calculate theta rad using xyz
        theta_rad = 2.0 * np.sign(tip_camFrame[2]) * np.arccos(tip_camFrame[2] / np.sqrt(
            tip_camFrame[0] * tip_camFrame[0] + tip_camFrame[1] * tip_camFrame[1] + tip_camFrame[2] * tip_camFrame[2]))
        tip_camFrame1 = np.array([0., 0., 0.])
        tip_camFrame1[0] = vector_top1[0] - vector_base1[0]
        tip_camFrame1[1] = vector_top1[1] - vector_base1[1]
        tip_camFrame1[2] = vector_top1[2] - vector_base1[2]

        if np.absolute(tip_camFrame1[0]) < 0.0001:
            phi_rad1 = np.pi / 2.0
        else:
            phi_rad1 = np.arctan(tip_camFrame1[1] / tip_camFrame1[0])
        theta_rad1 = 2.0 * np.sign(tip_camFrame1[2]) * np.arccos(tip_camFrame1[2] / np.sqrt(
            tip_camFrame1[0] * tip_camFrame1[0] + tip_camFrame1[1] * tip_camFrame1[1] + tip_camFrame1[2] *
            tip_camFrame1[2]))
        # tip_camFrame1=np.array([0., 0., 0.])
        return np.array([phi_rad, theta_rad, phi_rad1, theta_rad1])

    def getr0fromPhi(self, phi_rad):
        r0 = self.l_tri / np.sqrt(3) * np.cos(np.pi / 3) / np.cos(
            np.remainder(phi_rad + self.p1_off_set_angle, 2 * np.pi / 3) - np.pi / 3)
        return r0

    def getMCGfromR0andTheta(self, theta, r0):
        Izz = self.m0 * self.r0 * self.r0
        if theta == 0.:
            M = self.m0 * (self.L / 2) ** 2
            C = 0.
            G = -self.g * self.m0
        else:
            M = (Izz / 4 + self.m0 * ((np.cos(theta / 2) * (self.r0 - self.L / theta)) / 2 +
                                      (self.L * np.sin(theta / 2)) / theta ** 2) ** 2 + (
                             self.m0 * np.sin(theta / 2) ** 2 * (self.r0 - self.L / theta) ** 2) / 4
                 )
            C = (-(self.L * dtheta * self.m0 * (2 * np.sin(theta / 2) - theta * np.cos(theta / 2)) * (
                        2 * self.L * np.sin(theta / 2)
                        - self.L * theta * np.cos(theta / 2) + self.r0 * theta ** 2 * np.cos(theta / 2))) / (
                             2 * theta ** 5)
                 )
            G = (-(self.g * self.m0 * (
                        self.L * np.sin(theta) + self.r0 * theta ** 2 * np.cos(theta) - self.L * theta * np.cos(
                    theta))) / (2 * theta ** 2)
                 )
        return np.array([M, C, G])

    def step_response(self, pd_array, step_time, t0):
        try:
            while (time() - t0) <= step_time:
                self.send_zipped_socket0(pd_array)
        except KeyboardInterrupt:
            exit()

    def positionRampFromT0(self, t, x1_t0):
        xd = 0.
        dxd = 0.
        ddxd = 0.
        if t <= self.rampAmpAbs / self.rampRateAbs:
            xd = x1_t0 - self.rampRateAbs * t
            dxd = -self.rampRateAbs
            ddxd = 0.0
            self.flag_ramp_phase = 0
        elif t > self.rampAmpAbs / self.rampRateAbs and t <= self.rampAmpAbs / self.rampRateAbs + self.rampFlatTime:
            xd = x1_t0 - self.rampAmpAbs
            dxd = 0.0
            ddxd = 0.0
            self.flag_ramp_phase = 1
        elif t > self.rampAmpAbs / self.rampRateAbs + self.rampFlatTime and t <= (
                self.rampAmpAbs / self.rampRateAbs) * 2.0 + self.rampFlatTime:
            xd = x1_t0 - self.rampAmpAbs + self.rampRateAbs * (
                        t - (self.rampAmpAbs / self.rampRateAbs + self.rampFlatTime))
            dxd = self.rampRateAbs
            ddxd = 0.0
            self.flag_ramp_phase = 2
        else:
            xd = x1_t0
            dxd = 0.0
            ddxd = 0.0
            self.flag_ramp_phase = 3
        return np.array([xd, dxd, ddxd])

    def smart(self,segment_num, vector_MCG, vector_xd,  dt):
        theta = 0.
        dtheta = 0.
        s = 0.
        M = vector_MCG[0]
        C = vector_MCG[1]
        G = vector_MCG[2]
        f = 0.
        u_total = 0.
        ddxd = 0.0
        b_x = (self.alpha0 / M)
        f_x = (self.k0 * self.state_var_current[segment_num] + (self.b0 + C) * self.state_var_deri[segment_num] + G) / M
        #### mode switching ####
        if self.flag_stage[segment_num] == 0:
            if np.absolute(self.state_error_current[segment_num]) >= self.m_switch_pos_th:
                if np.absolute(self.smcNDOB_dist_est_inner_tqr[segment_num]) >= self.m_switch_tqr_th:
                    if self.flag_1st_contact[segment_num] == 0:
                        self.vector_xdc[segment_num] = self.state_var_current[segment_num]
                        self.vector_dxdc[segment_num] = 0
                        self.vector_ddxdc[segment_num] = 0
                    self.flag_stage[segment_num] = 1
                    xd = self.vector_xdc[segment_num]
                    dxd = self.vector_dxdc[segment_num]
                    ddxd = self.vector_ddxdc[segment_num]
            else:
                xd = vector_xd[0]
                dxd = vector_xd[1]
                ddxd = vector_xd[2]
        elif self.flag_stage[segment_num] == 1:
            if np.absolute(self.smcNDOB_dist_est_inner_tqr[segment_num]) >= self.m_switch_tqr_th:
                xd = self.vector_xdc[segment_num]
                dxd = 0
                ddxd = 0
            else:
                if self.flag_1st_contact[segment_num] == 1:
                    self.flag_1st_contact[segment_num] = 0
                xd = self.state_var_current[segment_num] - np.sign(self.state_error_current[segment_num]) * self.m_switch_pos_th
                dxd = -self.m_switch_pos_th
                ddxd = 0.0
                self.flag_stage[segment_num] = 2
        else:
            if np.absolute(self.state_error_current[segment_num]) >= self.m_switch_pos_th:
                if np.absolute(self.smcNDOB_dist_est_inner_tqr[segment_num]) >= self.m_switch_tqr_th:
                    xd = self.state_var_current[segment_num] - np.sign(self.state_error_current[segment_num]) * self.m_switch_pos_th
                    dxd = -self.m_switch_pos_th
                    ddxd = 0.0
                else:
                    self.flag_stage[segment_num] = 1
                    xd = self.vector_xdc[segment_num]
                    dxd = 0
                    ddxd = 0
            else:
                xd = vector_xd[0]
                dxd = vector_xd[1]
                ddxd = vector_xd[2]

        s = self.smcNDOB_lambda[segment_num] * self.state_error_current[segment_num] + self.state_error_deri[segment_num]
        if np.absolute(s / self.smcNDOB_sat_bound[segment_num]) <= 1:
            sat_s = s / self.smcNDOB_sat_bound[segment_num]
        else:
            sat_s = np.sign(s)
        u_eq = -1.0 / b_x * (f_x + self.smcNDOB_lambda[segment_num] * self.state_error_deri[segment_num] - ddxd + self.smcNDOB_k_sig[segment_num] * s)
        u_s = -1.0 / b_x * self.smcNDOB_eta[segment_num] * sat_s
        u_n = -1.0 / b_x * self.smcNDOB_dist_est_inner[segment_num]
        u_total = u_eq + u_s + u_n
        # Update smcNDOB estimation
        self.smcNDOB_dz_inner[segment_num] = -self.smcNDOB_kp_sig[segment_num] * (
                    -self.smcNDOB_k_sig[segment_num] * s + b_x * (u_n + u_s) + self.smcNDOB_dist_est_inner[segment_num])
        self.smcNDOB_z_current_inner[segment_num] = self.smcNDOB_z_old_inner[segment_num] + self.smcNDOB_dz_inner[segment_num] * dt
        self.smcNDOB_dist_est_inner[segment_num] = self.smcNDOB_z_current_inner[segment_num] + self.smcNDOB_kp_sig[segment_num] * s
        self.smcNDOB_z_old_inner[segment_num] = self.smcNDOB_z_current_inner[segment_num]
        self.smcNDOB_dist_est_inner_tqr[segment_num] = self.smcNDOB_dist_est_inner[segment_num] * M
        #### needs to pay attention
        sphi = np.sin(self.vector_phi[segment_num])
        cphi = np.cos(self.vector_phi[segment_num])
        pm2_MPa=self.pd_pm_array[2*self.num_of_seg-1+2*segment_num+2]/145.038
        pm3_MPa=pm2_MPa
        p1_MPa=(u_total/self.alpha0-(0.5*sphi+0.5*np.sqrt(3)*cphi)*pm2_MPa+sphi*pm3_MPa)/(0.5*sphi-0.5*np.sqrt(3)*cphi)
        p1_psi=p1_MPa*145.038
        if p1_psi<=0.0:
            p1_psi=0.0
        elif p1_psi>=40.0:
            p1_psi=40.0
        return p1_psi

    # def mode_switching_seg1(self, current_state, vector_xd_profile, state_error, smcNDOB_dist_est_tqr):
    #     if self.flag_stage == 0:
    #         if np.absolute(state_error) >= self.m_switch_pos_th:
    #             if np.absolute(smcNDOB_dist_est_tqr) >= self.m_switch_tqr_th:
    #                 if self.flag_1st_contact == 0:
    #                     self.vector_xdc[0] = current_state
    #                     dxd = 0
    #                     ddxd = 0
    #                 self.flag_stage = 1
    #         else:
    #             xd = vector_xd_profile[0]
    #             dxd = vector_xd_profile[1]
    #             ddxd = vector_xd_profile[2]
    #     elif self.flag_stage == 1:
    #         if np.absolute(smcNDOB_dist_est_tqr) >= self.m_switch_tqr_th:
    #             xd = self.vector_xdc[0]
    #             dxd = 0
    #             ddxd = 0
    #         else:
    #             if self.flag_1st_contact == 1:
    #                 self.flag_1st_contact = 0
    #             xd = vector_current_xd[0] - np.sign(state_error)*self.m_switch_pos_th
    #             dxd = -self.m_switch_pos_th
    #             ddxd = 0.0
    #             self.flag_stage = 2
    #     else:
    #         if np.absolute(state_error) >= self.m_switch_pos_th:
    #             if np.absolute(smcNDOB_dist_est_tqr) >= self.m_switch_tqr_th:
    #                 xd = vector_current_xd[0] - np.sign(state_error) * self.m_switch_pos_th
    #                 dxd = -self.m_switch_pos_th
    #                 ddxd = 0.0
    #             else:
    #                 self.flag_stage = 1
    #                 xd = self.vector_xdc[0]
    #                 dxd = 0
    #                 ddxd = 0
    #         else:
    #             xd = vector_xd_profile[0]
    #             dxd = vector_xd_profile[1]
    #             ddxd = vector_xd_profile[2]
    #     return np.array([xd, dxd, ddxd])

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

    def recv_zipped_socket2(self, flags=0):
        """reconstruct a Python object sent with zipped_pickle"""
        zobj = self.socket2.recv(flags)
        pobj = zlib.decompress(zobj)
        return pickle.loads(pobj)

    def recv_zipped_socket3(self, flags=0):
        """reconstruct a Python object sent with zipped_pickle"""
        zobj = self.socket3.recv(flags)
        pobj = zlib.decompress(zobj)
        return pickle.loads(pobj)

    def recv_cpp_socket2(self):
        strMsg = self.socket2.recv()
        # floatArray=np.fromstring(strMsg)
        return np.fromstring(strMsg, dtype=float, sep=' ')
