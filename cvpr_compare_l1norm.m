function dst=cvpr_compare_l1norm(F1, F2)

dst = sum(abs(F1 - F2));

return;