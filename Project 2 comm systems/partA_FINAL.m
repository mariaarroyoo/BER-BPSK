N = 200 %number of symbols
ran_binary = rand(1, N) > 0.5 %generating binary sequence with equal probability of 0s and 1s

%map orthogonal representation:
a = 2*ran_binary - 1 %0s become -1 and 1s become 1s. As for Eb = 1, A is 1 
plot(a(1,:),0, '.') %plotting it!
xlabel('phi1')
ylabel('phi2')
title('Orthogonal representation of bipolar signaling')
axis
grid on

%generate a 0 mean awgn signal:
SNRdB = 0 %SNR is dBs
Eb = 1 % total energy of the signal
%the variance of any noise variable is No/2
SNR = 10^(SNRdB/10) %formula to convert from dBs to natural units
No = Eb/SNR 
variance = No/2 %the variance is 0.5 for Eb / No = 0dB
n1 = sqrt(variance).*randn(1,1) %one awgn variable with zero mean

%creating the procedure 1000 times 
for count = 1:1000
gaussianrndnv = sqrt(variance).*randn(1, N); %creating the 200 uncorrelaed zero-mean gaussian randn variables with variance 0.5
y = a + gaussianrndnv;
sr = real(y) > 0; %decoding -> getting the original sequence
errors(count) = size(find([ran_binary - sr]),2); %gets number of error
end

%compute the likelihood: (applying the definition)
likelihood1 = 1/(2*pi*sqrt(variance))*exp(-(y - 1)/(2*sqrt(variance))) % A = 1
likelihood2 = 1/(2*pi*sqrt(variance))*exp(-(y + 1)/(2*sqrt(variance))) % A = -1

BER = errors/N %this is the simulated BER that we get with the specific SNRdB

%now with the different SNRdB values:
SNRdBarray = [0 2 4 6 8]
for count2 = 1:length(SNRdBarray)
    gaussianrndnv = 10^(-SNRdBarray(count2)/20).*randn(1, N); %creating the 200 uncorrelaed zero-mean gaussian randn variables with variance 0.5
    y = a + gaussianrndnv;
    sr = real(y) > 0; %decoding -> getting the original sequence
    errors2(count2) = size(find([ran_binary - sr]),2); %find(x) finds the entries that are non zero. size counts the size of the matrix.

end

%calculating the simulated and the theoretical BER values
BER = errors2/N
theoreticalBER = 0.5*erfc(sqrt(10.^(SNRdBarray/10)));

%plotting both of them in the same graph
figure
semilogy(SNRdBarray,theoreticalBER,'b.-');
hold on
semilogy(SNRdBarray,BER,'mx-');
axis([0 10 10^-5 0.5])
grid on
legend('theory', 'simulation');
xlabel('SNR, dB');
ylabel('BER');
title('BER probability curve for bipolar signaling');


