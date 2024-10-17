import numpy as np
import matplotlib.pyplot as plt

total_samples = 410322  # number of total samples used in the study
positive_ratio = 0.1  # ratio of positive results out of all samples
total_pos = positive_ratio * total_samples  # number of positive result
total_neg = total_samples - total_pos  # number of negative result

labels = ['Precision', 'Recall', 'Accuracy', 'F1-score', 'MCC']

nTrials = 10000  # number of random trial
res = np.zeros((nTrials, 5))  # initialize array for results
cntFound = 0  # initialize 

for i in range(nTrials):
    TPR = np.random.rand()  # randomly generate true positive rate
    TNR = np.random.rand()  # randomly generate true negative rate

    TP = total_pos * TPR  # number of true positive sample
    TN = total_neg * TNR  # number of true negative sample
    FN = total_pos - TP  # number of false negative sample
    FP = total_neg - TN  # number of false positive sample

    res[i, 0] = TP / (TP + FP)  # precision
    res[i, 1] = TP / (TP + FN)  # recall
    res[i, 2] = (TP + TN) / (TP + TN + FP + FN)  # accuracy
    res[i, 3] = 2 * res[i, 0] * res[i, 1] / (res[i, 0] + res[i, 1])  # F1-score
    res[i, 4] = (TP * TN - FP * FN) / np.sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN))  # MCC

    # check if all the measures fall within the 0.05 range
    if np.all(np.abs(np.diff(res[i, :])) <= 0.05):
        cntFound += 1
        outstr = f'idx : {i}'
        for j in range(5):
            outstr += f', {labels[j]}: {res[i, j]}'
        print(outstr)  # display results of the test

print(f'{cntFound}/{total_samples} = {cntFound / total_samples * 100:.2f}%')

# plot all the measures
plt.figure(10)
for i in range(4):
    plt.subplot(4, 1, i + 1)

    # draw the result of randomly generated trials
    plt.plot(res[:, 4], res[:, i], 'k.')

    # draw red line where x = y
    plt.plot([0, 1], [0, 1], 'r')

    plt.xlabel('MCC')
    plt.ylabel(labels[i])

plt.subplot(4, 1, 1)
plt.title(f'positive ratio = {positive_ratio}')
plt.tight_layout()
plt.show()

