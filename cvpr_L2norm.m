function dst=cvpr_L2norm(F1, F2)

x = F1 - F2;
x = x.^2;
x = sum(x);
dst = sqrt(x);

return;
