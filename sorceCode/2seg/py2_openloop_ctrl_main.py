"""
This code is the PC Client
normal to compliant to recovery 
recorvery to compliant


"""
import p1_main
import ml_main
import p23_main
from time import time,sleep
import numpy as np
def main():
    try:
        #### Select control method ####
        flag_ctrl_mode=2
        if flag_ctrl_mode==0:
            p_client=cali_main.pc_client()
        elif flag_ctrl_mode==1:
            p_client=p1_main.pc_client()
        elif flag_ctrl_mode==2:
            p_client=ml_main.pc_client()
        elif flag_ctrl_mode==3:
            p_client=p23_main.pc_client()
        elif flag_ctrl_mode==4:
            p_client=tau_main.pc_client()
        elif flag_ctrl_mode==5:
            p_client=tau_main_xy.pc_client()
        elif flag_ctrl_mode==6:
            p_client=workspace_main.pc_client()

        p_client.th2.start()
        sleep(0.5)
        p_client.th1.start()
        while 1:
            pass
    except KeyboardInterrupt:
        p_client.th1_flag=False
        p_client.th2_flag=False
        p_client.socket0.unbind("tcp://10.203.48.122:4444")#
        exit()
if __name__ == '__main__':
    main()
