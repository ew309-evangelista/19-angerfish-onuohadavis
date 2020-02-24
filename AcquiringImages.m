clear all;
close all;
clc;

[cam,prv] = initWebcam;
pause(2.0);
im = prv.CData;

eyes = figure('Parent',0);
axs = axes('Parent',eyes);
img = imshow(im,'Parent',axs);
axs.NextPlot = 'add';
%hold on
y = plot([320 320],[0 480],'r','Parent',axs);
x = plot([0 640],[240 240],'r','Parent',axs);
cnt = plot([0],[0],'ko','MarkerSize',10,'Parent',axs);

while(1)
    im = prv.CData;
    img.CData = im;
    drawnow
    
    [target,maskedRGBimage] = orange2(im);
    targetFill = imfill(target,'holes');
    
    minArea = 100;
    maxArea = 153600;
    minEcc = 0;
    maxEcc = 0.75;
    
    targetMinArea = bwareaopen(targetFill,minArea);
    
    [lbl,n] = bwlabel(targetMinArea); %n = number of labeled targets
    
    stats = regionprops(lbl,'area','centroid','eccentricity');
    %"cent = stats(2).Centroid" will give the centroid of the second object
    %detected
    
    idx = find(...
        [stats.Eccentricity] <= maxEcc);
    
    if idx > 0   
        cent1 = stats(1).Centroid
        cnt.XData = [cent1(1)];
        cnt.YData = [cent1(2)];
    end
end