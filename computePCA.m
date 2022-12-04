function e=computePCA(t_allfeat) 

e=getEigenModel(t_allfeat);

e=deflateEigen(e, 3); 



return;