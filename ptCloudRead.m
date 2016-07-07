% ptc = pcread('D:\Code\photogrammetry\imageSequences\Glaciers\GL1\PG1\test1.0.ply')
% showPointCloud(ptc)
close all
clear all

dat = load('D:\Code\photogrammetry\imageSequences\Glaciers\GL1\PG1\picking_listTest2.txt')

x = dat(:,1)
y = dat(:,2)
z = dat(:,3)

scatter3(x,y,z,'filled','k')

X = linspace(min(x),max(x),5)
Y = linspace(min(y),max(y),5)

XX = meshgrid(X)
YY = meshgrid(Y)

f = fit([x, y], z, 'poly11' )
zf = f(XX,YY')

hold on
surf(X,Y,zf)

xm = (max(x)+min(x))/2
ym = (max(y)+min(y))/2
pa1 = xm
pa2 = min(y)
pb1 = max(x)
pb2 = ym

pa = f(pa1, pa2)
pb = f(pb1, pb2)
pz = f(xm, ym)

pa = [pa1, pa2, pa]
pb = [pb1, pb2, pb]
pz = [xm, ym, pz]
points = [pa;pb;pz]

va = (pa-pz)
vb = (pb-pz)
vn = cross(va,vb)

La = sqrt((va(1)^2)+(va(2)^2)+(va(3)^2))
Lb = sqrt((vb(1)^2)+(vb(2)^2)+(vb(3)^2))
L = (La+Lb)/2
Ln = sqrt((vn(1)^2)+(vn(2)^2)+(vn(3)^2))
vn = vn./(Ln/L)

nda = acos(sum(vn.*va)/(La*Lb)) 
nda = nda*(180/pi)
ndb = acos(sum(vn.*vb)/(La*Lb))  
ndb = ndb*(180/pi)

nvec = [pz; pz+vn]
avec = [pz; pz+va]
bvec = [pz; pz+vb]
plot3(nvec(:,1), nvec(:,2), nvec(:,3),'r','linewidth',2)
plot3(avec(:,1), avec(:,2), avec(:,3),'b','linewidth',2)
plot3(bvec(:,1), bvec(:,2), bvec(:,3),'b','linewidth',2)
plot3(points(:,1),points(:,2),points(:,3),'ro')


