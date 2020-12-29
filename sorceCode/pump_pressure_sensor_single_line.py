"""
This code is single line pump pressure sensor controller.
Required hardware list:
	1. DAC board for pump control input u.
	2. ADC board for reading analog pressrue sensor.
Required lib. list:
	1. adafruit dac
	2. ads 1015
"""
import numpy as np
import zmq
import Adafruit_MCP4725 as DAC
from ads1015 import ADS1015 

class controller(object):
	"""docstring for controller"""
	def __init__(self):
		# ADC and DAC
		self.adc=ADS1015()# use A0 read pressure
		self.adc.set_mode('single')
		self.adc.set_programmable_gain(6.144)
		self.adc.set_sample_rate(1600)

		self.dac=DAC.MCP4725()
		self.dac.set_voltage(0)

		# pid
		self.pe_max=5.0#psi
		self.pid_kp=1.0

	def p_type_feedback(self,pd):
		v_in=self.adc.get_voltage(channel=0)# volts
		pm=(v_in-0.1*5)*4.0/(0.8*5.0)*14.5038# Double Check with your own sensor mapping from voltage to pressrue
		u=self.pid_kp*(pd-pm)

		v_out = u / self.pe_max * 4095 # int 0-4095 maps to 0-5.0 volts

		if v_out>=4095:
			v_out=4095
		elif v_out<=0:
			v_out=0
		self.dac.set_voltage(int(v_out))

def main():
	try:
		single_line_controller=controller()
		pd=5.0# psi
		while 1:
			single_line_controller.p_type_feedback(pd)
	except KeyboardInterrupt:
		exit()

if __name__ == '__main__':
    main()



		