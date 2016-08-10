function [Grid] = getGMCgrid(country, admin,n)
% function [Grid] = getGMCgrid(country, admin,n)
% generate the GCM grid with top left pixel corner lat 90, long -180
% degrees with n degree pixel length (~5600m x 5600m). J.Fohring 2016





% -----------------------------------------------------------
% ISO code for country should be a string.
% Admin level is numberic
% input: country = country id from Global Administrative area
%          admin = numberic value (0,1,2,3..) for administrative area level
%                    0: country border
%                    1: provincial borders
%              n = degree spaceing / grid resolution
%__________________________________________________________
filename = [country '_adm' num2str(admin) '.shp'];

% read shape file for specific country and admin level
[S, ~] = shaperead(filename, 'UseGeoCoords',true);

% get the bounding box coordinates
bbox = S.BoundingBox; % [min x min y; max x max y] [min long, min lat; max long, max lat]


% extract regional mesh from big GCM mesh
Grid.World.lat  = -90:n:90;
Grid.World.long = -180: n: 180;

Grid.World.latcc  = Grid.World.lat(1:end-1) + n/2;
Grid.World.longcc = Grid.World.long(1:end-1) + n/2;

% extract cell center points within the bounding box
ind = find(Grid.World.latcc >= bbox(1,2)  & Grid.World.latcc <= bbox(2,2));
Grid.Country.latcc = Grid.World.latcc(ind);

ind = find( Grid.World.longcc >= bbox(1,1)   & Grid.World.longcc <= bbox(2,1));
Grid.Country.longcc = Grid.World.longcc(ind);

Grid.BoundingBox = bbox;

%% plot for testing
% rough center average of country bounding box
cent = (bbox(1,:) + bbox(2,:))/2;

figure(1),clf
geoshow(filename)
axis([bbox(1,1) bbox(2,1) bbox(1,2) bbox(2,2)])
hold on
plot(bbox(1,1), bbox(1,2),'r*',bbox(2,1),bbox(1,2),'r*', 'MarkerSize',5)
plot(bbox(1,1), bbox(2,2),'r*',bbox(2,1),bbox(2,2),'r*', 'MarkerSize',5)
plot(cent(1), cent(2),'bo', 'MarkerSize',5,'LineWidth',4)
Grid.Country.longcc = Grid.World.longcc(ind);

