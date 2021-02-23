# Simple Forward Model
Simple example illustrating how to fit a forward model on EEG data

## Introduction

This repo contains one EEG recording of one volunteer listening to an audiobook whilst a 64-channel EEG recording was acquired. The EEG data has been pre-processed (band-pass filtered between 1 and 12 Hz and resampled to 50 Hz), and the corresponding speech envelopes extracted. The EEG data and envelopes are divided in 4 parts of approximately the same duration, adding up to a total of about 10 minutes of data.

We model the brain responses during listening to continuous speech by a linear model: `eeg = env * trf`, where * is the convolution symbol, `eeg` is the timeseries of one EEG channel, `env` is the envelope of the speech stimulus and `trf` is the Temporal Response Function (TRF) of that particular channel, which represents the underlying brain response to speech. This is a forward or encoding model that describes how a particular stimulus feature gives rise to neural activity. Measuring `eeg` and knowing `env`, we are interested in calculating the neural response `trf`. We will attempt this through deconvolution in the time domain.

## Quick start

### Installation
Add the `functions` folder to your path.

### Run
`synthetic_forward_model.m`: illustrate deconvolution of an synthetic TRF.

`forward_model.m`: fit a forward model on real EEG data using the speech envelope as predictor.

## Content

`data`: folder containing the EEG data & envelope
`functions`: folder containing the required functions. These include a few functions from the [EEGLAB toolbox](https://github.com/sccn/eeglab), included here for convenience to represent scalp maps (topoplot function).
