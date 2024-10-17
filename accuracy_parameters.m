total_samples = 410322; % number of total samples used in the study
positive_ratio = 0.1; % ratio of positive results out of all samples
total_pos = positive_ratio*total_samples; % number of positive result
total_neg = total_samples-total_pos; % number of negative result

labels = {'Precision', 'Recall', 'Accuracy', 'F1-score', 'MCC'};


nTrials = 10000; % number of random trial
res = zeros(nTrials,5); % initialize array for results
cntFound = 0; % initialize 

for i=1:nTrials

	TPR = rand(1); % randomly generate true positive rate
	TNR = rand(1); % randomly generate true negative rate
	% TPR = rand(1)*.5+.5; % randomly generate true positive rate with specific range
	% TNR = rand(1)*.5+.5; % randomly generate true negative rate with specific range
	
	TP = total_pos*TPR; % number of true positive sample
	TN = total_neg*TNR; % number of true negative sample
	FN = total_pos-TP; % number of false negative sample
	FP = total_neg-TN; % number of false positive sample
	
	res(i,1) = TP/(TP+FP); % precision
	res(i,2) = TP/(TP+FN); % recall
	res(i,3) = (TP+TN)/(TP+TN+FP+FN); % accuracy
	res(i,4) = 2*res(i,1)*res(i,2)/(res(i,1)+res(i,2)); % F1-score
	res(i,5) = (TP*TN-FP*FN)/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN)); % MCC

	% check if all the measures fall within the 0.05 range
	if isempty(find(abs(diff(res(i,:))) > 0.05, 1))
		cntFound = cntFound + 1;
		outstr = ['idx : ', num2str(i)];
		for j=1:5
			outstr = [outstr, ', ', labels{j}, ':', num2str(res(i,j))];
		end
		disp(outstr); % display results of the test
	end

end

disp([num2str(cntFound), '/', num2str(total_samples), ' = ', num2str(cntFound/total_samples * 100) '%']);

%% plot all the measures
figure(10);
for i=1:4
	subplot(4,1,i);

	% draw the result of randomly generated trials
	plot(res(:,5), res(:,i), 'k.');

	% draw red line where x = y
	pl1 = line([0, 1], [0, 1]);
	pl1.Color = 'r';
	
	xlabel('MCC');
	ylabel(labels{i})
end

subplot(4,1,1);
hold on;
title(['positive ratio = ', num2str(positive_ratio)]);
hold off;

