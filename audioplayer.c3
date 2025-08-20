// original c source file is from:
//https://glusoft.com/sdl3-tutorials/play-music-sdl3_mixer/

module audioplayer;

import sdl3;
import std::io;
// type and functions used below defined in sdl3_mixer.h
alias Mix_Music=void;
extern fn bool open_audio(AudioDeviceID devid,AudioSpec* spec) @extern("Mix_OpenAudio");
extern fn Mix_Music* load_music(ZString file) @extern("Mix_LoadMUS");
extern fn bool play_music(Mix_Music* music,int loops) @extern("Mix_PlayMusic");
//-----------------

const SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK =(AudioDeviceID) 0xFFFFFFFFu;
String musicPath = "E:\\codetyphon\\CodeOcean\\01_Sounds\\sky.mp3";

fn int main(String[] argv)
{
    String musicFile;
    if(argv.len<2)
    {
        musicFile=musicPath;
    }
    else
    {
        musicFile=argv[1];
    }
      if(!file::exists(musicFile))
    {
        io::printfn("File %s doesn't exist.",(ZString)argv[1]);
        io::printfn("Usage: audioplayer [filename]");
        return -1;
    }


    sdl3::init(subsystem::VIDEO | subsystem::AUDIO | subsystem::EVENTS);
    defer sdl3::quit();

    Window* win = sdl3::create_window("SDL3 Music Project",640, 480, 0);
    defer sdl3::destroy_window(win);
    if (win == null) {
        io::printf("SDL_CreateWindow Error: %s.",sdl3::get_error());
        sdl3::quit();
        return 1;
    }

    Renderer* ren = sdl3::create_renderer(win, null);
    defer sdl3::destroy_renderer(ren);
    if (ren == null) {
        io::printf("SDL_CreateRenderer Error: %s.",sdl3::get_error());
        sdl3::destroy_window(win);
        sdl3::quit();
        return 1;
    }

    // init SDL Mixer
    AudioDeviceID audioDevice = sdl3::open_audio_device(SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, null);
    if (!audioDevice) {
        io::printf("SDL_OpenAudioDevice Error: %s",sdl3::get_error());
        sdl3::destroy_window(win);
        sdl3::quit();
    }

    if (!open_audio(audioDevice, null)) {
        io::printf("Mix_OpenAudio Error: %s.",sdl3::get_error());
        sdl3::destroy_window(win);
        sdl3::quit();
    }
    
  
    Mix_Music* music = load_music((ZString)musicFile);
    if (!music) {
        io::printf("Mix_LoadMUS Error: %s",sdl3::get_error());
        sdl3::destroy_window(win);
        sdl3::quit();
    }

    // play the music (does not loop)
    play_music(music, 0);
    Event e;
    bool quit = false;

    // Define a rectangle
    FRect greenSquare ={270, 190, 100, 100};

    while (!quit) {
        while (sdl3::poll_event(&e)) {
            if (e.type == event_type::QUIT) {
                quit = true;
            }
        }

        sdl3::set_render_draw_color(ren, 0, 0, 0, 255); // Set render draw color to black
        sdl3::render_clear(ren); // Clear the renderer

        sdl3::set_render_draw_color(ren, 0, 255, 0, 255); // Set render draw color to green
        sdl3::render_fill_rect(ren, &greenSquare); // Render the rectangle
        
        sdl3::render_present(ren); // Render the screen
    }

    return 0;
}