title '';
axis off;
set(gcf, 'Units', 'centimeters', 'InnerPosition', [53, 5, 8, 8]);
ylim([-500,500]);
xlim([-500,500]);

print(gcf, 'd05d_n216_16_rect_steel_surf_29300','-depsc', '-r600');
