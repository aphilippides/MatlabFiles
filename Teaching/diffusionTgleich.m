function diffusionTgleich (Anzahl, Dauer, xMax, yMax, f)

% DIFFUSIONTGLEICH(ANZAHL,DAUER,XMAX,YMAX) shows the diffusion of
% two different types of particles (each type consists of 0.5*anzahl
% particles). For more information see diffusionT.m.
% The distribution of the particles concerning the x-value
% is plotted afterwards.
%
% DIFFUSIONTGLEICH(ANZAHL,DAUER) uses xMax = 40, yMax = 30.
%
% DIFFUSIONTGLEICH uses anzahl = 20, dauer = 100 in addition.

% This file was generated by students as a partial fulfillment 
% for the requirements of the course "Fractals", Winter term
% 2004/2005, Stuttgart University.	

% Author : Fabian Hansch, Stefanie Schetter
% Date   : Dec 2004
% Version: 1.0


% default setting
if (nargin < 4)
    xMax = 40;
    yMax = 30;
end
if (nargin < 2)
    Anzahl = 20;
    Dauer = 100;
end

% even number of particles
Anzahl = round(Anzahl/2)*2;
Zaehler1 = zeros(xMax+1, Dauer);
Zaehler2 = zeros(xMax+1, Dauer);
Position = zeros(2, Anzahl);
Richtung = zeros(1, Anzahl);
% The particles are initialised separately (left -- right)
if(nargin<5) f=0.5; end;
for i = 1:(Anzahl/2)
    Richtung(1, i) = rand(1)*2*pi;
    Position(1, i) = rand(1)*(xMax*f);
    Position(2, i) = rand(1)*yMax;
end;
for i = (Anzahl/2)+1:Anzahl
    Richtung(1, i) = rand(1)*2*pi;
    Position(1, i) = xMax*(1-f) + rand(1)*xMax*f;
    Position(2, i) = rand(1)*yMax;
end;

clf;
axis square; axis equal;

% simulate the diffusion
for i = 1 : Dauer
    hold off;
    plot([0, 0, xMax, xMax, 0], [0, yMax, yMax, 0, 0], 'b-');
    hold on;
    plot([-10, -10, xMax+10, xMax+10, -10], [-10, yMax+10, yMax+10, -10, -10], 'b-');
    for j = 1:Anzahl
        % plot the first half of the particles
        if (j <= Anzahl/2) 
            plot(Position(1, j), Position(2, j), 'r.');
            Zaehler1(round(Position(1, j)+1), i) = Zaehler1(round(Position(1, j)+1), i)+1;
        else
        % plot the second half
            plot(Position(1, j), Position(2, j), 'b.');
            Zaehler2(round(Position(1, j)+1), i) = Zaehler2(round(Position(1, j)+1), i)+1;
        end;
        for t = 1:Anzahl
            % is there another particle that hits the current one?
            if (t ~= j) & (sqrt((Position(1, j)-Position(1, t))^2 + (Position(2, j)-Position(2, t))^2))<=1
                if (Position(1, t) ~= Position(1, j))
                    Lot = atan((Position(2, t)-Position(2, j))/(Position(1, t)-Position(1, j)));
                else
                    Lot = pi/2;
                end;
                % calculate the new directions
                alpha1 = Richtung(1, j);
                alpha2 = Richtung(1, t);
                Richtung(1, j) = mod(2*Lot - alpha2, 2*pi);
                Richtung(1, t) = mod(2*Lot - alpha1, 2*pi);
            end;
        end;
        % calculate the new positions
        Position(1, j) = Position(1, j) + 2*cos(Richtung(1, j));
        Position(2, j) = Position(2, j) + 2*sin(Richtung(1, j));
        if (Position(1, j) >= xMax)
            Richtung(1, j) = pi - Richtung(1, j);
            Position(1, j) = xMax;
        end;
        
        % is there a wall?
        if (Position(1, j) <= 0)
            Richtung(1, j) = pi - Richtung(1, j);
            Position(1, j) = 0;
        end;
        if (Position(2, j) >= yMax)
            Richtung(1, j) = 2*pi - Richtung(1, j);
            Position(2, j) = yMax;
        end;
        if (Position(2, j) <= 0)
            Richtung(1, j) = 2*pi - Richtung(1, j);
            Position(2, j) = 0;
        end;
        Richtung(1, j) = mod(Richtung(1, j), 2*pi);
    end;
    if (i == 1) 
        pause; 
    else 
        pause (1/24); 
    end;
end;
pause;

% evaluation of the distribution of the particles over the elapsed time
% the number of particles are summed along the y-direction
x = 1:xMax+1;
y = 0; 
for a = 1:xMax+1
    for b = 1:Dauer
        if (Zaehler1(a, b)>=y) y = Zaehler1(a, b); end;
        if (Zaehler2(a, b)>=y) y = Zaehler2(a, b); end;
    end;
end;
y = y + 3;
for i = 1:Dauer
    axis square; axis equal;
    clf;
    hold on;
    plot ([1, xMax+1, xMax+1, 1, 1], [0, 0, y, y, 0], 'k-');
    plot (Zaehler1(x, i), 'r-');
    plot (Zaehler2(x, i), 'b-');
    hold off;
    if (i == 1) pause; else pause (1/6); end;
end;