%Part B
N = 200 %number of modulated symbols per slot
rand_binary = rand(1, N) > 0.5 %we create 200 binary sequence with equal probability of 1s and 0s
%plot the orthogonal representation
a = rand_binary*sqrt(2) %A = sqrt(2) so that Eb = 1
plot(a(1,:),0, '.') %plotting it!
xlabel('phi1')
ylabel('phi2')
title('Orthogonal representation of unipolar signaling')
axis
grid on

SNRdB = [0 2 4 6 8]
for count = 1:length(SNRdB)
    gaussianrndnv = 10^(-SNRdB(count)/20).*randn(1, N); %creating the 200 uncorrelaed zero-mean gaussian randn variables with variance 0.5
    y = a + gaussianrndnv
    sr = real(y) > 0; %decoding -> getting the original sequence
    errors(count) = size(find([rand_binary - sr]),2);

end

%calculating the simulated and the theoretical BER values
BER = errors/N
theoreticalBER = 0.5*erfc(sqrt(10.^(SNRdB/10)));

%plotting both of them in the same graph
figure
semilogy(SNRdB,theoreticalBER,'b.-');
hold on
semilogy(SNRdB,BER,'mx-');
axis([0 8 10^-5 0.5])
grid on
legend('theory', 'simulation');
xlabel('SNR, dB');
ylabel('BER');
title('BER probablity curve for unipolar signaling');

