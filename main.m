% ECE_161C 2020 Modem Design Problem. HW-1 SQRT Nyquist Filters.
clear all; close all; clc;
%% Problem 1
%using 6-subplots instead of 4-subplots for clearer view of zoom to
%passband ripple.

%h1=rcosine(1,4,'sqrt',0.25,10);
%{
rcosdesign(beta,span,sps,shape)
filter energy is 1
beta or rolloff = 0.25
span = 10
symbols per second = 4
shape = 'sqrt'
%}
%{
problem: rcosine() not supported in matlab 2017 version and rcosdesign()
produces an array of length 41, expecting array of length 81.

solution: run "h1=rcosine(1,4,'sqrt',0.25,10);" on Matlab online compiler,
save result as a '.mat' file and load file onto local Matlab.
%}
%importing '.mat' file from Matlab online compiler

%{
Designing the pulse shaping filter
-using rcosine() with 'sqrt' shape to form a sinc function
-sinc function in time domain corresponds to a rectangular function in
frequency domain
-symbol energy normalized to 1
-alpha is the rolloff factor, reduced rolloff factor looks more like a
rectangular waveform in the frequency domain
-smaller tail amplitude reduces |S| effect with a higher rolloff factor at
the cost of a higher bandwidth.
%}

%alpha = 0.25
load('h1_rcosine_0p25alpha.mat') %loads 'h1=rcosine(1,4,'sqrt',0.25,10);'
scl_1=max(h1);
h1=h1/scl_1; 
% h1=sqrt_nyq_y2(8,0.20,10,0);  % replace cos taper with harris taper 
figure(1)
subplot(2,3,1) 
plot(-10:1/4:10,h1,'linewidth',2) 
hold on 
%overplotting red 'o' at every 4th sample to see the |S| terms
plot(-10:1:10,h1(1:4:81),'ro','linewidth',2) 
hold off 
grid on 
axis([-10 10 -0.3 1.2]) 
title('Cosine Taper Sqrt Nyquist Filter, \alpha=0.25 ') 
xlabel('Time Index') 
ylabel('Amplitude') 

%frequency domain analysis using fast fourier transform and shifting the
%zero frequency to the center of the spectrum.
fh1=fftshift(20*log10(abs(fft(h1/sum(h1),1000)))); 
subplot(2,3,2) 
plot((-0.5:1/1000:0.5-1/1000)*4,fh1,'linewidth',2) 
grid on 
axis([-1 1 -70 5]) 
title('Frequency Response, \alpha=0.25, f_S=4') 
xlabel('Frequency') 
ylabel('Amplitude')

%Zoomed plot of the passband ripple of the frequency response waveform.
subplot(2,3,3) 
%axes('position',[0.421 0.14 0.194 0.1])
plot((-0.5:1/1000:0.5-1/1000)*4,fh1-0.015,'linewidth',2) 
grid on 
axis([-0.5 0.5 -0.04 0.04]) 
title('Frequency Response, Zoom to Passband Ripple, \alpha=0.25') 
xlabel('Frequency') 
ylabel('Log Mag (dB)')

%repeating for an increased rolloff factor

%alpha = 0.5
load('h2_rcosine_0p5alpha.mat') %loads h2=rcosine(1,4,'sqrt',0.5,10);
scl_2=max(h2);
h2=h2/scl_2;
subplot(2,3,4) 
plot(-10:1/4:10,h2,'linewidth',2) 
hold on 
plot(-10:1:10,h2(1:4:81),'ro','linewidth',2) 
hold off 
grid on 
axis([-10 10 -0.3 1.2]) 
title('Cosine Taper Sqrt Nyquist Filter, \alpha=0.5 ') 
xlabel('Time Index') 
ylabel('Amplitude') 

fh2=fftshift(20*log10(abs(fft(h2/sum(h2),1000)))); 
subplot(2,3,5) 
plot((-0.5:1/1000:0.5-1/1000)*4,fh2,'linewidth',2) 
grid on 
axis([-1 1 -70 5]) 
title('Frequency Response, \alpha=0.5, f_S=4') 
xlabel('Frequency') 
ylabel('Amplitude')

subplot(2,3,6) 
%axes('position',[0.421 0.14 0.194 0.1])
plot((-0.5:1/1000:0.5-1/1000)*4,fh2-0.015,'linewidth',2) 
grid on 
axis([-0.5 0.5 -0.04 0.04]) 
title('Frequency Response, Zoom to Passband Ripple, \alpha=0.5') 
xlabel('Frequency') 
ylabel('Log Mag (dB)')

%% Problem 2
figure(2) 

%alpha =0.25
%convolving and plotting the pulse shaping filter with the matched filter
hh1=conv(h1,h1)/(h1*h1'); 
subplot(2,3,1) 
plot(-20:1/4:20,hh1,'linewidth',2) 
hold on 
plot(-20:1:20,hh1(1:4:161),'ro','linewidth',2) 
hold off 
grid on 
axis([-13 13 -0.3 1.2])
title('Matched Filter Response Cosine Taper Sqrt Nyquist Filter, \alpha=0.25') 
xlabel('Time Index') 
ylabel('Amplitude')

%plotting frequency response using fft() and shifting zero component to
%center of spectrum
fhh1=fftshift(20*log10(abs(fft(hh1/sum(hh1),1000)))); 
subplot(2,3,2) 
plot((-0.5:1/1000:0.5-1/1000)*4,fhh1,'linewidth',2) 
grid on 
axis([-1 1 -70 5])
title('Frequency Response, \alpha=0.25, f_S=4') 
xlabel('Frequency') 
ylabel('Amplitude') 

%plotting the zoom to passband ripple of the frequency response
subplot(2,3,3) 
plot((-0.5:1/1000:0.5-1/1000)*4,fhh1-0.026,'linewidth',2) 
grid on 
axis([-0.5 0.5 -0.08 0.08]) 
title('Frequency Response, Passband Ripple, \alpha=0.25') 
xlabel('Frequency') 
ylabel('Log Mag (dB)')

%repeating for rolloff factor of 0.5
%alpha =0.5
hh2=conv(h2,h2)/(h2*h2'); 
subplot(2,3,4) 
plot(-20:1/4:20,hh2,'linewidth',2) 
hold on 
plot(-20:1:20,hh2(1:4:161),'ro','linewidth',2) 
hold off 
grid on 
axis([-13 13 -0.3 1.2])
title('Matched Filter Response Cosine Taper Sqrt Nyquist Filter, \alpha=0.5') 
xlabel('Time Index') 
ylabel('Amplitude')

fhh2=fftshift(20*log10(abs(fft(hh2/sum(hh2),1000)))); 
subplot(2,3,5) 
plot((-0.5:1/1000:0.5-1/1000)*4,fhh2,'linewidth',2) 
grid on 
axis([-1 1 -70 5])
title('Frequency Response, \alpha=0.5, f_S=4') 
xlabel('Frequency') 
ylabel('Amplitude') 

subplot(2,3,6) 
plot((-0.5:1/1000:0.5-1/1000)*4,fhh2-0.026,'linewidth',2) 
grid on 
axis([-0.5 0.5 -0.08 0.08]) 
title('Frequency Response, Passband Ripple, \alpha=0.5') 
xlabel('Frequency') 
ylabel('Log Mag (dB)')

%% QPSK modulation 
%% Problem 3
%forming QPSK time series
x0=(floor(2*rand(1,1000))-0.5)/0.5+j*(floor(2*rand(1,1000))-0.5)/0.5; 
x1=zeros(1,4000); 
x1(1:4:4000)=x0; 

%alpha = 0.25
x2a=filter(h1,1,x1); 
figure(3) 
subplot(2,1,1) 
plot(0:1/4:60,real(x2a(1:241)),'linewidth',2) 
hold on 
%plotting the first 50 symbols of the shaped time series
plot((0:50)+10,real(x1(1:4:201)),'ro','linewidth',2) 
hold off 
grid on
title('Real Part BPSK Input Samples and SQRT Nyquist Time Response, 4 SPS, Excess BW \alpha = 0.25') 
xlabel('Time Index (in Symbols)') 
ylabel('Amplitude') 

%alpha = 0.5
x2b=filter(h2,1,x1); 
figure(3) 
subplot(2,1,2) 
plot(0:1/4:60,real(x2b(1:241)),'linewidth',2) 
hold on 
plot((0:50)+10,real(x1(1:4:201)),'ro','linewidth',2) 
hold off 
grid on
title('Real Part BPSK Input Samples and SQRT Nyquist Time Response, 4 SPS, Excess BW \alpha = 0.5') 
xlabel('Time Index (in Symbols)') 
ylabel('Amplitude') 

%% Problem 4
% 1024-tap kaiser windowing
figure(4) 
ww=kaiser(1024,8)'; 
ww=10*ww/sum(ww); 

%alpha = 0.25
ff1=zeros(1,1024); 
m=0; 
for k=1:250:4000-1023 
     ff=abs(fft(x2a(k:k+1023).*ww)).^2;
     ff1=ff1+ff; 
     m=m+1; 
end
subplot(2,1,1) 
%plotting average modulated power
plot((-0.5:1/1024:0.5-1/1024)*4,fftshift(10*log10(ff1/m)),'linewidth',2.5) 
hold on
%overplotting single modulated power
plot((-0.5:1/1024:0.5-1/1024)*4,fftshift(10*log10(ff)),'k','linewidth',1) 
%plotting the shaping filter
plot((-0.5:1/1000:0.5-1/1000)*4,fh1-0.001,'r','linewidth',2) 
hold off 
grid on 
axis([-2 2 -60 10]) 
title('Spectra: SQRT Nyquist Filter (Red), 4 SPS, \alpha=0.25, Average Modulated Power (Blue), and Single Modulated Power (Black)')
xlabel('Frequency') 
ylabel('Log Mag (dB)')
%repeat for increased rolloff factor
%alpha = 0.5
ff2=zeros(1,1024); 
m=0;
for k=1:250:4000-1023
     ff=abs(fft(x2b(k:k+1023).*ww)).^2;
     ff2=ff2+ff; 
     m=m+1; 
end
subplot(2,1,2) 
plot((-0.5:1/1024:0.5-1/1024)*4,fftshift(10*log10(ff2/m)),'linewidth',2.5) 
hold on
plot((-0.5:1/1024:0.5-1/1024)*4,fftshift(10*log10(ff)),'k','linewidth',1) 
plot((-0.5:1/1000:0.5-1/1000)*4,fh2-0.001,'r','linewidth',2) 
hold off 
grid on 
axis([-2 2 -60 10]) 
title('Spectra: SQRT Nyquist Filter (Red), 4 SPS, \alpha=0.5, Average Modulated Power (Blue), and Single Modulated Power (Black)')
xlabel('Frequency') 
ylabel('Log Mag (dB)')

%% Problem 5
figure(5) 
%alpha = 0.25
%plotting the eye diagrams representing electrical measurements that are
%data dependent
subplot(2,1,1) 
plot(0,0) 
hold on
%overlaying different bit transistions
for n=41:8:4000-8     
    plot(-1:1/4:1,real(x2a(n:n+8)),'b') 
end 
hold off 
grid on 
axis([-1 1 -2 2])
title('Eye Diagram, Real Part QPSK Modulated Signal, 4 SPS, \alpha=0.25') 
xlabel('Time Index (Symbols)') 
ylabel('Amplitude')

%alpha = 0.5
subplot(2,1,2) 
plot(0,0) 
hold on
%overlaying different bit transitions
for n=41:8:4000-8     
    plot(-1:1/4:1,real(x2b(n:n+8)),'b') 
end 
hold off 
grid on 
axis([-1 1 -2 2])
title('Eye Diagram, Real Part QPSK Modulated Signal, 4 SPS, \alpha=0.5') 
xlabel('Time Index (Symbols)') 
ylabel('Amplitude')

%% Problem 6
figure(6)
%QPSK uses four phase representation on the constellation diagram
%represents the signal modulated by a digital modulation scheme, in this
%case a quad-phase shift keying modulation

%alpha = 0.25
subplot(1,2,1)
%plotting the transition diagram
plot(x2a) 
hold on 
%overplotting the constellation diagram
plot(x2a(1:4:4000),'.r') 
hold off
grid on 
axis([-2 2 -2 2 ]) 
axis('square') 
title('QPSK Modulation Transition Diagram (Blue) and Constellation (Red), \alpha=0.25')

%repeating for increased rolloff factor
%alpha = 0.5
subplot(1,2,2) 
plot(x2b) 
hold on 
plot(x2b(1:4:4000),'.r') 
hold off
grid on 
axis([-2 2 -2 2 ]) 
axis('square') 
title('QPSK Modulation Transition Diagram (Blue) and Constellation (Red), \alpha=0.5')

%% Problem 7
figure(7) 

%alpha = 0.25
%passing the shaping filter through the matched filter (matched shaping
%filter, timing matched)
x3a=filter(h1,1,x2a)/(h1*h1'); 
subplot(2,1,1) 
%plotting the matched shaping filter
plot(0:1/4:120,real(x3a(1:481)),'linewidth',2) 
hold on 
%overplotting the real part of the timing series
plot((0:100)+20,real(x1(1:4:401)),'or','linewidth',2) 
hold off 
grid on 
axis([0 120 -2 2]) 
title('Real Part QPSK Matched Filter Time Response (Blue) and Detected Samples (Red), 4-SPS, \alpha = 0.25') 
xlabel('Time index (Symbols)') 
ylabel('Amplitude') 

%repeating for increased rolloff factor
%alpha = 0.5
x3b=filter(h2,1,x2b)/(h2*h2'); 
subplot(2,1,2) 
plot(0:1/4:120,real(x3b(1:481)),'linewidth',2) 
hold on 
plot((0:100)+20,real(x1(1:4:401)),'or','linewidth',2) 
hold off 
grid on 
axis([0 120 -2 2]) 
title('Real Part QPSK Matched Filter Time Response (Blue) and Detected Samples (Red), 4-SPS, \alpha = 0.5') 
xlabel('Time index (Symbols)') 
ylabel('Amplitude') 

%% Problem 8
figure(8) 

%eye diagram of matched filtered time series

%alpha = 0.25
subplot(2,1,1) 
plot(0,0)
hold on
%plotting the eye diagram by overlaying different bit transitions
for n=81:4:4000-8     
    plot(-1:1/4:1,real(x3a(n:n+8)),'b') 
end 
hold off 
grid on 
title('Eye Diagram, Real Part QPSK Matched Filter Response, 4 SPS, \alpha=0.25') 
xlabel('Time Index (Symbols)') 
ylabel('Amplitude') 

%repeating for increased rolloff factor
%alpha = 0.5
subplot(2,1,2) 
plot(0,0)
hold on
for n=81:4:4000-8     
    plot(-1:1/4:1,real(x3b(n:n+8)),'b') 
end 
hold off 
grid on 
title('Eye Diagram, Real Part QPSK Matched Filter Response, 4 SPS, \alpha=0.5') 
xlabel('Time Index (Symbols)') 
ylabel('Amplitude') 

%% Problem 9
figure(9) 

%plotting the constellation diagrams of each matched filtered time series

%alpha =0.25
subplot(1,2,1) 
%plotting transition diagrams for the matched filter
plot(x3a) 
hold on 
%plotting the constellation diagram
plot(x3a(81:4:4000),'.r') 
hold off 
grid on
axis([-2 2 -2 2 ]) 
axis('square') 
title('QPSK Matched Filter Transition Diagram (Blue) and Constellation (Red), \alpha=0.25')

%repeating for rolloff factor of 0.5
%alpha =0.5
subplot(1,2,2) 
plot(x3b) 
hold on 
plot(x3b(81:4:4000),'.r') 
hold off 
grid on
axis([-2 2 -2 2 ]) 
axis('square') 
title('QPSK Matched Filter Transition Diagram (Blue) and Constellation (Red), \alpha=0.5')

%% Problem 10 (wasn't labeled on hw write-up but on gradescope submission)
figure(10) 

%plotting constellation point |S| smearing
%alpha = 0.25
subplot(1,2,1) 
plot(abs(real(x3a(81:4:4000))),abs(imag(x3a(81:4:4000))),'ro') 
grid on 
axis([0.95 1.05 0.95 1.05 ]) 
axis('square') 
title('Constellation Point ISI Smearing, \alpha=0.25')

%alpha = 0.5
subplot(1,2,2) 
plot(abs(real(x3b(81:4:4000))),abs(imag(x3b(81:4:4000))),'ro') 
grid on 
axis([0.95 1.05 0.95 1.05 ]) 
axis('square') 
title('Constellation Point ISI Smearing, \alpha=0.5')