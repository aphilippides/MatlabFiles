% function to get a random integer between 0 and MaxNum

function[NewNum]=IRnd(MaxNum)

NewNum=min(floor(rand*MaxNum),MaxNum-1);
