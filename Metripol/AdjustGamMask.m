function[news]=AdjustGamMask(s,mask,gam)
func=inline(['imadjust(x,[],[],' num2str(gam) ');']);
news=roifilt2(s,mask,func);