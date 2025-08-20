
module minimal;

import sdl3;
import sdl3::event_type;
import sdl3::subsystem;
import sdl3::window_flags;

fn int main(String[] args)
{
    if (sdl3::init(subsystem::VIDEO | subsystem::EVENTS) < 0)
    {
        sdl3::log_error("sdl3 init failed: %s", sdl3::get_error());
        return -1;
    }
    defer sdl3::quit();

    sdl3::Window* window = sdl3::create_window(
        "An SDL3 window", 640, 480,
        window_flags::RESIZABLE|window_flags::MOUSE_FOCUS
    );
    sdl3::Renderer* renderer = sdl3::create_renderer(window, null);
    sdl3::show_window(window);

    defer sdl3::destroy_window(window);
    defer sdl3::destroy_renderer(renderer);

    bool is_running = true;

    while (is_running)
    {
        sdl3::Event e;
        if (sdl3::wait_event(&e))
        {
            switch (e.type)
            {
                case event_type::QUIT:
                    is_running = false;
            }
        }

        sdl3::set_render_draw_color(renderer, 0, 255, 0, 255);
        sdl3::render_clear(renderer);
        sdl3::render_present(renderer);
    }

    return 0;
}

