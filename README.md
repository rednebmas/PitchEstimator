Pitch Estimator
===============
A framework for accurate pitch estimation. A unique feature of this pitch estimator is that attempts to find the fundamental frequency (i.e. what octave), not just the note.

The bin interpolation method used to improve the accuracy of the pitch estimator is from [Improving FFT Frequency Measurement Resolution
by Parabolic and Gaussian Interpolation](https://mgasior.web.cern.ch/mgasior/pap/FFT_resol_note.pdf) by Gasior and Gonzalez who work at CERN.

This framework also includes some other music utilities such a note class for converting a frequency to a note name and vice versa.

