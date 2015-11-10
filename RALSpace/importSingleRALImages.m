% this is a helper function which allows quick renaming of images to speed
% exporting single images form pixpro

function importSingleRALImages

% Images taken on 9/6/2015 in Tilt tes
% Order of images
% Images from 19: 90
% 72 images, 3 sets of 24
% pictures are taken at 3 tilts, 0, 10 and 20. We do 3 sets of 8 at one tilt
% Each set is at 0, 1, 2 and 4m from a starting position going towards a target tree at 2 orientations. 
% one picture taken heading to the tree, Set1_Tilt20_D2_0, one picture taken at 90 degrees CCW, Set1_Tilt20_D2_90, so 2 pics at each of the  location
% Set 1: cluttered. Order: 0, 10, 20
imn=19;
for Tilt=[0 10 20]
    for d=[0 1 2 4]
        for h=[0 90]
            unw=imread(['100_00' int2str(imn) '(1).jpg']);
            of=['Set1_Tilt' int2str(Tilt) '_D' int2str(d) '_' int2str(h) '.mat'];
            save(of,'unw');
            imn=imn+1;
        end
    end
end

% Set 2: cluttered. Order: 20, 10, 0
for Tilt=[20 10 0]
    for d=[0 1 2 4]
        for h=[0 90]
            unw=imread(['100_00' int2str(imn) '(1).jpg']);
            of=['Set2_Tilt' int2str(Tilt) '_D' int2str(d) '_' int2str(h) '.mat'];
            save(of,'unw');
            imn=imn+1;
        end
    end
end

% Set 3: open. Order: 0, 10, 20
for Tilt=[0 10 20]
    for d=[0 1 2 4]
        for h=[0 90]
            unw=imread(['100_00' int2str(imn) '(1).jpg']);
            of=['Set3_Tilt' int2str(Tilt) '_D' int2str(d) '_' int2str(h) '.mat'];
            save(of,'unw');
            imn=imn+1;
        end
    end
end
    