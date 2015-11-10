function[Hol_spheint] = hol_spheintS(t,r,a,b,tim,B)

Hol_spheint = my_spheintS(t,r,b,tim,B) - my_spheintS(t,r,a,tim,B);

