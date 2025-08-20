// original c source file is from:
// https://lazyfoo.net/tutorials/SDL/02_getting_an_image_on_the_screen/index.php
module loadbmp;

import sdl3;
import sdl3::event_type;
import sdl3::subsystem;
import sdl3::window_flags;
import std::io;

const SCREEN_WIDTH=640;
const SCREEN_HEIGHT=480;

Window* gWindow=null;
Surface* gScreenSurface=null;
Surface* gHelloWorld=null;
fn int main(String[] args)
{
    if(!init())
    {
        sdl3::log("Failed to intialize!\n");
    }
    else
    {
        if(!loadMedia())
        {
            sdl3::log("Failed to load media!\n");
        }
        else
        {
            sdl3::blit_surface(gHelloWorld,null,gScreenSurface,null);
            sdl3::update_window_surface(gWindow);
            
            Event e;
            bool quit=false;
            while(quit==false)
            {
                while(sdl3::poll_event(&e))
                {
                    if(e.type==event_type::QUIT)
                    {
                        quit=true;
                    }
                }
            }
        }
    }
    
    close();
                
    return 0;
}

fn void close()
{
    sdl3::destroy_surface(gHelloWorld);
    
    gHelloWorld=null;
    
    sdl3::destroy_window(gWindow);
    gWindow=null;
    
    sdl3::quit();
}

fn bool loadMedia()
{
    bool success=true;
    
    gHelloWorld=sdl3::load_bmp("e:/lazarus/ex/img/phong.bmp");
    if(gHelloWorld==null)
    {
        sdl3::log("Unable to load image %s! sdl error:%s\n","omega.bmp",sdl3::get_error());
        success=false;
    }
    
    return success;
}


fn bool init()
{
    bool success=true;
    if(sdl3::init(subsystem::VIDEO|subsystem::EVENTS)<0)
    {
        sdl3::log("sdl could not intialize! sdl error:%s\n",sdl3::get_error());
        success=false;
    }
    else
    {
        gWindow=sdl3::create_window("SDL tutorial",SCREEN_WIDTH,SCREEN_HEIGHT,0);
        if(gWindow==null)
        {
            sdl3::log("Window could not be created!sdl error:%s\n",sdl3::get_error());
            success=false;
        }
        else
        {
            gScreenSurface=sdl3::get_window_surface(gWindow);
        }
    }
    return success;
}