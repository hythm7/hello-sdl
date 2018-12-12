use SDL2::Raw;
use SDL2::Ext;

use SnakeGame::Window;
use SnakeGame::Renderer;
use SnakeGame::Snake;
use SnakeGame::Food;

constant W = 400;
constant H = 400;

class SnakeGame {
  has Int $.width;
  has Int $.height;

	has SDL_Color $.background;
	has SDL_Color $.snakecolor;

	has $!renderer;
	has $!window;

	has SnakeGame::Food  $!food;
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
		$!food = SnakeGame::Food.new();
  }

  enum GAMEKEYS (
    K_UP    => 82,
    K_DOWN  => 81,
    K_LEFT  => 80,
    K_RIGHT => 79,
  );

	method start () {

	  my $snakedir = RIGHT;

	  my $event = SDL_Event.new;

		main: loop {

			while SDL_PollEvent($event) {
				my $casted-event = SDL_CastEvent($event);
				last main if $casted-event.type ~~ QUIT;
			  
				if $casted-event.type ~~ KEYDOWN {
          $snakedir = LEFT  if $casted-event.scancode == +LEFT;
          $snakedir = RIGHT if $casted-event.scancode == +RIGHT;
          $snakedir = DOWN  if $casted-event.scancode == +DOWN;
          $snakedir = UP    if $casted-event.scancode == +UP;
				}
			}

     self.update(:$snakedir);
		 self.render();

		 SDL_Delay(200);
		}

	}

	method !init-game () {
    
	}



  method update (:$snakedir) {
    $!snake.move(:$snakedir);

		$!food .= new if SDL_HasIntersection($!snake.head.rect, $!food.rect);
	  
	}

  method render () {
    $!renderer.draw-color($!background.r, $!background.g, $!background.b, $!background.a);
	  $!renderer.clear;
    $!renderer.draw-color($!food.color.r, $!food.color.g, $!food.color.b, $!food.color.a);
    $!renderer.fill-rect($!food.rect);

    $!renderer.draw-color($!snake.color.r, $!snake.color.g, $!snake.color.b, $!snake.color.a);

    loop (my $p = $!snake.head; $p; $p .= prev) {
      $!renderer.fill-rect($p.rect);
		}

		$!renderer.present;

	}


  method end () {
    $!renderer.destroy;
    $!window.destroy;
	}



}
