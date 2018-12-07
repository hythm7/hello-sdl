#!/usr/bin/env perl6

use lib <lib>;

use SDL2::Raw;
use SDL2::Ext;
use SDL2::Img;
use SDL2::TTF;

constant W  = 500;
constant H  = 500;

my SDL_Window   $win;
my SDL_Renderer $ren;
my SDL_Rect     $rec;
my SDL_Point    @points;

SDL_Init(VIDEO);

$win = SDL_CreateWindow(
  "Hello SDL!",
	SDL_WINDOWPOS_CENTERED_MASK, SDL_WINDOWPOS_CENTERED_MASK,
	W, H,
	SHOWN);

$ren = SDL_CreateRenderer( $win, -1, ACCELERATED );


TTF_Init();
my $font = TTF_OpenFont('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 27);
TTF_SetFontStyle($font, TTF_STYLE_BOLD);
TTF_SetFontOutline($font, 1);
TTF_SetFontHinting($font, TTF_HINTING_NORMAL);

my SDL_Color $color1 = SDL_Color.new(:r(0), :g(0),   :b(0));
my SDL_Color $color2 = SDL_Color.new(:r(255),   :g(255), :b(255));

my SDL_Surface $fnt-sur = TTF_RenderText_Shaded($font, 'Hello Hello!', $color1, $color2);
my SDL_Texture $fnt-tex = SDL_CreateTextureFromSurface($ren, $fnt-sur);

my SDL_Surface $cat-sur = IMG_Load( 'img/cat.png' );
my SDL_Texture $cat-tex = SDL_CreateTextureFromSurface($ren, $cat-sur);


$rec = SDL_Rect.new(:x(32), :y(32), :w(32), :h(32));

enum GAME_KEYS (
    K_UP    => 82,
    K_DOWN  => 81,
    K_LEFT  => 80,
    K_RIGHT => 79,
    K_SPACE => 44,
);


my $event = SDL_Event.new;

main: loop {

  while SDL_PollEvent($event) {
    my $casted-event = SDL_CastEvent($event);
    last main if $casted-event.type ~~ QUIT;
		update($casted-event) if $casted-event.type ~~ KEYDOWN;
    render();
	}

}

SDL_DestroyTexture($fnt-tex);
SDL_DestroyTexture($cat-tex);
SDL_FreeSurface($fnt-sur);
SDL_FreeSurface($cat-sur);
SDL_DestroyRenderer($ren);
SDL_DestroyWindow($win);

SDL_Quit;

sub render {
  SDL_SetRenderDrawColor($ren, 0, 0, 0, 255);
	clear();
	#draw-font();
	draw-cat();
	present();
#	draw-lines();
}

sub update ($casted-event) {
  $rec.x -= 4 if $casted-event.scancode == +K_LEFT;
  $rec.x += 4 if $casted-event.scancode == +K_RIGHT;
  $rec.y -= 4 if $casted-event.scancode == +K_UP;
  $rec.y += 4 if $casted-event.scancode == +K_DOWN;
}

sub draw-font {
  SDL_RenderCopy($ren, $fnt-tex, SDL_Rect, SDL_Rect);
}

sub draw-cat {
  SDL_RenderCopy($ren, $cat-tex, SDL_Rect, $rec);
}

sub draw-lines {
  SDL_SetRenderDrawColor($ren, 0, 255, 255, 255);
	clear();
	present();
	SDL_Delay(500);
	clear();

  SDL_SetRenderDrawColor($ren, 255, 0, 0, 255);
	SDL_RenderDrawLine($ren, 10, 10, 490, 490 );
	present();
	SDL_Delay(500);

  SDL_SetRenderDrawColor($ren, 0, 0, 0, 255);
	SDL_RenderDrawPoint( $ren, 490 - $_ * 10, 10 + $_ * 10 ) for ^48;
	present();
	SDL_Delay(500);
 
	my $rec = SDL_Rect.new: :x(260), :y(10), :w(230), :h(230); 
  SDL_SetRenderDrawColor($ren, 0, 255, 0, 255);
	SDL_RenderDrawRect( $ren, $rec );
	present();
	SDL_Delay(500);

	$rec.x = 10;
	$rec.y = 260;
	SDL_SetRenderDrawBlendMode( $ren, BLENDMODE_BLEND );
  SDL_SetRenderDrawColor($ren, 0, 0, 255, 128);
	SDL_RenderFillRect( $ren, $rec );
	present();
	SDL_Delay(500);

  @points.push: SDL_Point.new(x => (^500).rand, y => (^500).rand) for ^500 ;
  SDL_SetRenderDrawColor($ren, 128, 128, 128, 255);
	SDL_RenderDrawPoint($ren, .x, .y) for @points;
	present();
	SDL_Delay(1000);

}

sub present {
  SDL_RenderPresent($ren);
}

sub clear {
  SDL_RenderClear($ren);
}
