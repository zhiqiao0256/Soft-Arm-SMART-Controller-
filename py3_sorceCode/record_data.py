#record_data.py    
#modified: December 2022
""" 
This code reads data from the local socket in this PC and exports the data into a structured txt file.

"""

#Import Libraries:
import numpy as np
from time import time,sleep,gmtime, strftime
#ZMQ Communication Libraries:
import zmq
import zlib
import pickle


class recordFromLocalHost(object):
    """docstring for recordFromLocalHost"""
    def __init__(self):
        context = zmq.Context()
        self.socket0=context.socket(zmq.SUB) ### sub to PC socket0
        self.socket0.setsockopt(zmq.SUBSCRIBE,b'')
        self.socket0.setsockopt(zmq.CONFLATE,True)
        self.socket0.connect("tcp://127.0.0.1:5555")

    #Receive Message Data    
    def recv_zipped_pickle(self,flags=0):
        """reconstruct a Python object sent with zipped_pickle"""
        zobj = self.socket0.recv(flags)
        pobj = zlib.decompress(zobj)
        return pickle.loads(pobj)


def main():
    try:
        file_name='data3.txt'
        lines=""
        print (file_name)
        input("Press Enter to Start.")
        pc_record=recordFromLocalHost()  #this is the variable to call the main object with functions
        
        #Test receive first message:
        msg=pc_record.recv_zipped_pickle()
        print(msg)

        print("Data Recording started...")

        with open(file_name,'w+') as data_file:
            msg=pc_record.recv_zipped_pickle()
            t0=time()
            told=t0
            while True:
                msg=pc_record.recv_zipped_pickle() #receive message
                #Set Structure
                lines=str(round((time()-t0),6))+","+np.array2string(msg,separator=',').replace('[','').replace(']','').replace('\n','')+"\n"
                data_file.write(lines)
                data_file.flush()
                print(str(round((time()-t0),6)))
                # sleep(0.01)
                told=time()
    except KeyboardInterrupt:
        print("Data Recording Finished.")
        exit()


if __name__ == '__main__':
    main()

