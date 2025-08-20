import std::io;
import sdl3;

extern fn bool ttf_init() @extern("TTF_Init");
extern fn TTF_Font* ttf_open_font(ZString* file,float ptsize) @extern("TTF_OpenFont");
extern fn Surface* ttf_render_text_lcd(TTF_Font* font,ZString text,isz length,Color fg,Color bg) @extern("TTF_RenderText_LCD");
extern fn void ttf_quit() @extern("TTF_Quit");

alias TTF_Font=void;

String text="Hello World!¡Hola Mundo!Γειά σου Κόσμε!Привет, мир!こんにちは世界！你好世界！";
String font_name="KosugiMaru-Regular.ttf";

fn void main()
{
    sdl3::init(subsystem::VIDEO|subsystem::EVENTS);
    defer sdl3::quit();

    ttf_init();
    defer ttf_quit();

    Window* window=sdl3::create_window("SDL3 unicode texts",860,300,window_flags::RESIZABLE);
    defer sdl3::destroy_window(window);

    if(!window)
    {
        io::printfn("Failed to create window: %s",sdl3::get_error());

        return;
    }

    Renderer* renderer=sdl3::create_renderer(window,null);
    defer sdl3::destroy_renderer(renderer);
    if(!renderer)
    {
        io::printfn("Failed to create renderer: %s",sdl3::get_error());
        
        return;
    }

    TTF_Font* font=ttf_open_font((ZString*)font_name.zstr_tcopy(), 16);
   
    if(!font)
    {
        io::printfn("Failed to load font: %s",sdl3::get_error());

        return;
    }

    
    Surface* textSurface=ttf_render_text_lcd(font,text.zstr_tcopy(),text.len,
        (Color){255,255,255,255},(Color){0,0,0,255});
    defer sdl3::destroy_surface(textSurface);

    FRect rect={35,50,(float)(textSurface.w),(float)(textSurface.h)};

    Texture* texture=sdl3::create_texture_from_surface(renderer,textSurface);
    defer sdl3::destroy_texture(texture);

    bool running=true;
    Event event;

    while(running)
    {
        while(sdl3::poll_event(&event))
        {
            if(event.type==event_type::QUIT|| (event.type==event_type::KEY_DOWN && event.keyboard.key==keycode::SDLK_ESCAPE))
            {
                running=false;
            }
        }

        sdl3::set_render_draw_color(renderer,0,0,0,255);
        sdl3::render_clear(renderer);

        sdl3::render_texture(renderer,texture,null,&rect);

        sdl3::render_present(renderer);
    }

}
