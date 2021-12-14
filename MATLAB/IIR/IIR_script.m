fs = 500e3;
fc = 30e3;
[b, a] = butter(4,fc/(fs/2));
%[z, p, k] = tf2zp(b, a);
%coeff = zp2sos(z, p, k);
%%%
%fvtool(coeff)
sys=tf(b,a, fs);
sys1=tf(b/a(3),a/a(3), fs);
sys1=sys1/dcgain(sys1);

bode(sys,'-', sys1,'--')


