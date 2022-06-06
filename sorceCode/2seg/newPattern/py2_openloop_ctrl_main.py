"""
This code is the PC Client
normal to compliant to recovery 
recorvery to compliant


"""
import seg1_main
import seg2_main
from time import time,sleep
import numpy as np
def main():
    try:
        #### Select control method ####
        flag_num_seg=1
        if flag_num_seg==1:
            sub_client_1=seg1_main.sub_seg()
        elif flag_ctrl_mode==2:
            sub_client_1=seg1_main.sub_seg()
            sub_client_2=seg2_main.sub_seg()
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
