function main 
    fn = dir('images\*.jpg');
    total_images = size(fn,1);
    
    %initialize template
    eyes = imread(strcat(fn(1).folder,'\', "BioID_0159.jpg")) 
    nose = imread(strcat(fn(1).folder,'\', "BioID_0242.jpg"))
    mouth = imread(strcat(fn(1).folder,'\', "BioID_0019.jpg"))
    eyes_template = eyes(75:100,25:55,1); %eyes template
    nose_template = nose(85:135,50:90,1); %nose template
    mouth_template = mouth(140:165,40:95,1); %mouth template
    correlation(eyes_template);
    pause();
    correlation(nose_template);
    pause();
    correlation(mouth_template);
    
    
function correlation (template)
    fn = dir('images\*.jpg');
    total_images = size(fn,1);
    collage = [];
    for image_idx = 1 : total_images
        image = imread( strcat(fn(image_idx).folder, '\', fn(image_idx).name) );
        x_dim = size(image,1);
        y_dim = size(image,2);
        % convert BW image to RGB to be able to display the rectangles in color
        imageRGB(:,:,1) = image;
        imageRGB(:,:,2) = image;
        imageRGB(:,:,3) = image;

        %calculate the correlation
        c = normxcorr2(template,image);
        peak = max(c(:));
        [y_peak, x_peak] = find(c==peak);
        
        %draw rectangles
        yoffSet = y_peak-size(template,1);
        xoffSet = x_peak-size(template,2);
        
        %uncomment these lines to see the overall performance
%         figure(2);
%         imshow(image);
%         drawrectangle('FaceAlpha',0, 'Color','r','Position',[xoffSet+1, yoffSet+1, size(template,2), size(template,1)]);
%         hold on;
        imageRGB(yoffSet+1:yoffSet+1+size(template,1),xoffSet+1:xoffSet+3,1) = 255;
        imageRGB(yoffSet+1:yoffSet+1+size(template,1),xoffSet+1:xoffSet+3,2) = 0;
        imageRGB(yoffSet+1:yoffSet+1+size(template,1),xoffSet+1:xoffSet+3,3) = 0;

        imageRGB(yoffSet+1:yoffSet+1+size(template,1),xoffSet+1+size(template,2):xoffSet+3+size(template,2),1) = 255;
        imageRGB(yoffSet+1:yoffSet+1+size(template,1),xoffSet+1+size(template,2):xoffSet+3+size(template,2),2) = 0;
        imageRGB(yoffSet+1:yoffSet+1+size(template,1),xoffSet+1+size(template,2):xoffSet+3+size(template,2),3) = 0;

        imageRGB(yoffSet+1:yoffSet+3,xoffSet+1:xoffSet+3+size(template,2),1) = 255;
        imageRGB(yoffSet+1:yoffSet+3,xoffSet+1:xoffSet+3+size(template,2),2) = 0;
        imageRGB(yoffSet+1:yoffSet+3,xoffSet+1:xoffSet+3+size(template,2),3) = 0;

        imageRGB(yoffSet+1+size(template,1):yoffSet+3+size(template,1),xoffSet+1:xoffSet+3+size(template,2),1) = 255;
        imageRGB(yoffSet+1+size(template,1):yoffSet+3+size(template,1),xoffSet+1:xoffSet+3+size(template,2),2) = 0;
        imageRGB(yoffSet+1+size(template,1):yoffSet+3+size(template,1),xoffSet+1:xoffSet+3+size(template,2),3) = 0;
        
        imageRGB = imcrop (imageRGB, [1,1,y_dim-1,x_dim-1]);
        %concatnate images
        collage = [collage, imageRGB];
        clear imageRGB;
    end
    %reshape
    collage = [collage(1:x_dim,1:5*y_dim,:); collage(1:x_dim,5*y_dim+1:10*y_dim,:) ;collage(1:x_dim,10*y_dim+1:15*y_dim,:);collage(1:x_dim, 15*y_dim+1:20*y_dim,:)];
    figure (3);
    imshow(collage);

