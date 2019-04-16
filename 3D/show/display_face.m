function display_face (shp, tex, tl, name)

%%%%%%%%%
%  shp tex   N*3
%  tl  N*3

%shp = [-shp(:,1) shp(:,2:3)];

set(gcf, 'Renderer', 'opengl');

trimesh(...
    tl, shp(:, 1), shp(:, 3), shp(:, 2), ...
    'EdgeColor', 'none', ...
    'FaceVertexCData', tex/255, 'FaceColor', 'interp', ...
    'FaceLighting', 'phong' ...
    );
set(gca, ...
    'DataAspectRatio', [ 1 1 1 ], ...
    'PlotBoxAspectRatio', [ 1 1 1 ], ...
    'Units', 'pixels', ...
    'GridLineStyle', 'none', ...
    'Visible', 'off', 'box', 'off', ...
    'Projection', 'perspective'...
    );
set(gca, ...
    'Units', 'pixels', ...
    'GridLineStyle', 'none', ...
    'Projection', 'perspective', ...
    'Visible', 'off'...
    );
%  'perspective'
set(gcf, 'Color', [ 1 1 1 ], 'InvertHardCopy', 'off');
view(180, 0);
set(gcf,'PaperPositionMode','auto');

if nargin >3
    saveas(gcf, name, 'jpg');
end

