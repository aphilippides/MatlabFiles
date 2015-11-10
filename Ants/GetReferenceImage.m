function[refimage,meaniqr]=GetReferenceImage(ns,fn,opt)

dwork;cd GantryProj\Bees\
sn=[fn(1:end-4) '.mat'];
if(isfile(sn)) 
    load(sn);
else
    a=aviinfo(fn);
    w=a.Width;
    h=a.Height
    f=aviread(fn,ns);
    % rows=zeros(length(ns),w,length(opt));
    % refimage=zeros(h,w,length(opt));
    % r2=zeros(h,w,length(opt));
    % ref_range=zeros(h,w,length(opt));
    rows=zeros(length(ns),w);
    refimage=zeros(h,w);
%    r2=zeros(h,w);
    ref_range=zeros(h,w);
    for j=1:h
        j
        for i=1:length(ns)
            %        rows(i,:,:)=f(i).cdata(j,1:w,opt);
            rows(i,:)=rgb2gray(f(i).cdata(j,1:w,:));
        end

        refimage(j,:)=median(rows(:,1:w));
        ref_range(j,:)=iqr(rows(:,1:w));

        %     for k=1:length(opt)
        %         refimage(j,:,k)=median(rows(:,1:w,k));
        %         r2(j,:,k)=mean(rows(:,1:w,k));
        %         ref_range(j,:,k)=iqr(rows(:,1:w,k));
        %     end
    end
    fi=f(1).cdata(1:h,1:w,:);
    colormap gray
    % subplot(3,1,1)
    % imagesc(refimage)
    % subplot(3,1,2)
    % imagesc(fi)
    % subplot(3,1,3)
    % imagesc(r2)
    meaniqr = mean2(ref_range)
    save(sn,'refimage','meaniqr');
end

% imagesc(refimage)
% figure
% colormap gray
% imagesc(fi)
% colormap gray