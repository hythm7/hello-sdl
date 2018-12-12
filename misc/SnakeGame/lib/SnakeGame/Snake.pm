use SDL2::Raw;
use SDL2::Ext;

enum SNAKEDIR (
  RIGHT => 79,
  LEFT  => 80,
  DOWN  => 81,
  UP    => 82,
);

class SnakeGame::Snake {

  class Piece {

	  has SDL_Rect $.rect is rw;
		has Piece    $.next is rw;
		has Piece    $.prev is rw;

	}

  has SDL_Color $.color;

  has Piece $.head;
  has Piece $.tail;

  submethod BUILD (
	  :$!color;
		) {
    
		self.grow();
		self.grow();
		self.grow();
		self.grow();
	  #$!head = Piece.new: rect => SDL_Rect.new(:x(400.rand.Int), :y(400.rand.Int), :w(14), :h(14));
  }

	method move (:$snakedir) {

		loop (my $p = $!tail; $p; $p .= next) {
      $p.rect.x = $p.next.rect.x if $p.next;
      $p.rect.y = $p.next.rect.y if $p.next;
		}

    $!head.rect.x -= 7 if $snakedir ~~ LEFT;
    $!head.rect.x += 7 if $snakedir ~~ RIGHT;
    $!head.rect.y += 7 if $snakedir ~~ DOWN;
    $!head.rect.y -= 7 if $snakedir ~~ UP;
		
	}

	method grow () {
    
	  my $piece = Piece.new: rect => SDL_Rect.new(:w(7), :h(7));

		if not $!head {
      $!head = $piece;
      $!tail = $piece;
			$piece.next = Nil;
			$piece.prev = Nil;
		}
		else {
      $!tail.prev = $piece;
			$piece.next = $!tail;
			$piece.prev = Nil;
			$!tail = $piece;
		}
	}
  

  method set-color (:$r, :$g, :$b) {
    $!color = SDL_Color.new(:$r, :$g, :$b);
	}

}
