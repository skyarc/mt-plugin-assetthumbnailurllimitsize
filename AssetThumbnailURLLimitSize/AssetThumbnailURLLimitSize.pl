package MT::Plugin::SKR::AssetThumbnailURLLimitSize;

use strict;
use base qw( MT::Plugin );
use Math::FitRect qw(fit_rect);

our $PLUGIN_NAME = 'AssetThumbnailURLLimitSize';
our $VERSION = '0.1';

my $plugin = __PACKAGE__->new({
    name     => $PLUGIN_NAME,
    version  => $VERSION,
    key      => lc $PLUGIN_NAME,
    id       => lc $PLUGIN_NAME,
    author_name => 'SKYARC Co.,Ltd.',
    author_link => 'http://www.skyarc.co.jp/',
    doc_link    => 'http://www.mtcms.jp/movabletype-blog/plugins/assetthumbnailurllimitsize/',
    description => $PLUGIN_NAME,
});

MT->add_plugin( $plugin );

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        tags => {
            function => {
                'AssetThumbnailURLLimitSize' => \&asset_thumbnail_url_limit_size,
            },
        },
    });
}

sub asset_thumbnail_url_limit_size {
    my ($ctx, $args) = @_; 
    my $a = $ctx->stash('asset')
        or return $ctx->_no_asset_error();
    my $class = ref($a);
    return '' unless UNIVERSAL::isa($a, 'MT::Asset::Image');

    return $a->url if $args->{width} > $a->image_width and $args->{height} > $a->image_height;

    my $new_rect = fit_rect(
        [$a->image_width, $a->image_height] => [$args->{width}, $args->{height}]
    );  
    my @url = $a->thumbnail_url(
        Width => $new_rect->{w},
        Height=> $new_rect->{h},
    );  
    return $url[0];
}

1;
__END__
