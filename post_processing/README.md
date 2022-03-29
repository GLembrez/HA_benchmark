# Post-processing the simulation

## script utilisation

The script postprocessing.m allows to export the timeseries from the simulation in a .json file. Each simulation outputs a data.m file containing the evolution of the state's variable in a timeserie called X. The signal can be transformed through the following operations :
* upsampling or downsampling : enabled when sampling is set to true. The parameter Ns sets the number of samples. The samples are collected by performing a linear interpolation on the system
* adding noise : two methods are available. First, using the awgn() function from the communication library. This adds additive white gaussian noise to a signal. The added noise is defined by the snr (signal to noise ratio) parameter. Snr is the quotient of signal power by noise power. Alternatively, normally distributed noise can be added to the signal. In this case, the parameter is the standard deviation.

## output format

the output file is in the .json format. For reference, see the example file

{ "t1" :
  {
    "v1" : "v1(t1)" ,
    "v2" : "v2(t1)" 
  },
  "t2" :
  {
    "v1" : "v1(t2)" ,
    "v2" : "v2(t2)" 
  },
  ...
}
