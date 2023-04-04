# Expectation-maximization algorithms for IS-NMF

This repository contains the code related to our paper titled [Expectation-maximization algorithms for Itakura-Saito nonnegative matrix factorization](https://hal.archives-ouvertes.fr/hal-01632082) published at Interpseech 2018. If you use the content of this repository, please cite our paper.


### Setup

This code was initially developed with Matlab, but we have adapted it to Octave. To use it, you need to install some Octave packages as follows:

	sudo apt install liboctave-dev
	sudo apt install octave-control
	sudo apt install octave-signal
	sudo apt install octave-dataframe	

Note that you can ignore `dataframe` if you don't intend to display the results using this tool.

The experiments use data from the [GRID corpus](https://spandh.dcs.shef.ac.uk/gridcorpus/). This dataset is devoted to audio-visual speech transcription, but here we only use the audio data, thus one only needs to download the audio at 25 kHz for a given pair of speakers, and place the unziped files in the `data/grid/` folder. In our paper, we used speakers `s1` and `s4`. You can use a different folder structure and/or speaker(s) as long as you change the path and speaker indices accordingly in the `global_setup.m` file. 


### Usage

To reproduce the results from our paper, run the scripts in order:

- `1.prepare_data.m` creates the mixtures and the dictionary audio files.
- `2.dico_learning.m` computes the NMF dictionaries for several dic. sizes.
- `3.separation.m` performs supervised source separation using the various NMF algorithms, and computes the SDR/SIR/SAR scores.
- `4.display_results.m` produces the figures and table from the paper.

