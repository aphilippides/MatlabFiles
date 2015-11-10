function[Hol_spheint] = hol_spheint(t,r,a,b)

Hol_spheint = my_spheint(t,r,b) - my_spheint(t,r,a);

