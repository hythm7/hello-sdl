use SDL2::Raw;
use SDL2::Ext;

use SnakeGame::Window;
use SnakeGame::Renderer;
use SnakeGame::Snake;

constant W = 400;
constant H = 400;

class SnakeGame {
  has Int $.width;
  has Int $.height;

	has SDL_Color $.background;
	has SDL_Color $.snakecolor;

	has $!renderer;
	has $!window;

	has SnakeGame::Snake $!snake;

  submethod BUILD (
	  :$!width  = W;
	  :$!height = H;

	  :$!background = SDL_Color.new(:r(0), :g(0), :b(0));
	  :$!snakecolor = SDL_Color.new(:r(0), :g(155), :b(0));
		) {

    SDL_Init(VIDEO);

		$!window    = SnakeGame::Window.new(:$!width, :$!height, :flags(SHOWN)); 
    $!renderer  = SnakeGame::Renderer.new($!window, :flags(ACCELERATED));

		$!snake = SnakeGame::Snake.new(:color($!snakecolor));
  }

  enum GAMEKEYS (
    K_UP    => 82,
    K_DOWN  => 81,
    K_LEFT  => 80,
    K_RIGHT => 79,
  );

	method start () {

	  my $direction = RIGHT;

	  my $event = SDL_Event.new;

		main: loop {

			while SDL_PollEvent($event) {
				my $casted-event = SDL_CastEvent($event);
				last main if $casted-event.type ~~ QUIT;
			  
				if $casted-event.type ~~ KEYDOWN {
          $direction = LEFT  if $casted-event.scancode == +LEFT;
          $direction = RIGHT if $casted-event.scancode == +RIGHT;
          $direction = DOWN  if $casted-event.scancode == +DOWN;
          $direction = UP    if $casted-event.scancode == +UP;
				}
			}

     self.update(:$direction);
		 self.render();

		 SDL_Delay(1000);
		}

	}

	method !init-game () {
    
	}



  method update (:$direction) {
    $!snake.go(:$direction);
	}

  method render () {
    $!renderer.draw-color($!background.r, $!background.g, $!background.b, $!background.a);
	  $!renderer.clear;
    $!renderer.draw-color($!snake.color.r, $!snake.color.g, $!snake.color.b, $!snake.color.a);
    $!renderer.fill-rect($!snake.head);
		$!renderer.fill-rect($!snake.body[0]);

		$!renderer.present;

	}


  method end () {
    $!renderer.destroy;
    $!window.destroy;
	}



}
