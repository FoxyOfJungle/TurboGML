
if !surface_exists(surf) {
    surf = surface_create(128, 128);
}
surface_set_target(surf);
draw_sprite(Sprite7, 0, 0, 0);
surface_reset_target();


draw_surface_centered_ext(surf, mouse_x, mouse_y, 1, 1, TIMER, c_white, 1);

