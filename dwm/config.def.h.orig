/* See LICENSE file for copyright and license details.*/

#include <X11/XF86keysym.h>
#include <X11/keysym.h>

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int gappih    = 10;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 10;       /* vert inner gap between windows */
static const unsigned int gappoh    = 10;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 10;       /* vert outer gap between windows and screen edge */
static const int swallowfloating    = 0;        /* 1 means swallow floating windows by default */
static const int swterminheritfs    = 1;        /* 1 terminal inherits fullscreen on unswallow, 0 otherwise */
static       int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const double activeopacity   = 1.0f;     /* Window opacity when it's focused (0 <= opacity <= 1) */
static const double inactiveopacity = 0.875f;   /* Window opacity when it's inactive (0 <= opacity <= 1) */
static       Bool bUseOpacity       = True;     /* Starts with opacity on any unfocused windows */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray             = 1;   /* 0 means no systray */
static const int refreshrate        = 165;      /* Update rate for drag and resize events, in updates (frames) per second */
static const char *fonts[]          = { "Cascadia Code:size=10" };
static const char dmenufont[]       = "Cascadia Code:size=10";

static const char col_normfg[] = "#fbf1c7";     /* fg0 */
static const char col_normbg[] = "#282828";     /* bg0 */
static const char col_normborder[] = "#504945"; /* bg2 */
static const char col_selfg[] = "#1d2021";      /* bg0_h */
static const char col_selbg[] = "#d65d0e";      /* Orange */
static const char col_selborder[] = "#fe8019";  /* lighter orange IG? */

static const unsigned int baralpha  = 0xA0;
static const unsigned int borderalpha = OPAQUE;

static const char *colors[][3] = {
    /*               fg         bg         border   */
    [SchemeNorm] = {col_normfg, col_normbg, col_normborder},
    [SchemeSel] = {col_selfg, col_selbg, col_selborder},
};

static const unsigned int alphas[][3]      = {

	[SchemeNorm] = { OPAQUE, baralpha, borderalpha },
	[SchemeSel]  = { OPAQUE, baralpha, borderalpha },
};

/* tagging */
static const char *tags[] = { "1:WWW", "2:DEV", "3:MUSIC", "4:CHAT", "5:GAME", "6:FILE", "7:EDIT", "8:ETC", "9:PASS" };
static const char *defaulttagapps[] = { "io.github.ungoogled_software.ungoogled_chromium", "st", "sh.cider.genten", "dev.vencord.Vesktop", "steam", "pcmanfm", NULL, NULL, "com.bitwarden.desktop"};

#define WTYPE "_NET_WM_WINDOW_TYPE_"
static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 *	_NET_WM_WINDOW_TYPE(ATOM) = wintype
	 */
  	/* class     instance    title           wintype         tags mask  isfloating  isterminal  noswallow  monitor */
  { NULL,          NULL,       NULL,           WTYPE "DIALOG",   0,         1,          0,          0,         -1 },
	{ NULL,          NULL,       NULL,           WTYPE "UTILITY",  0,         1,          0,          0,         -1 },
	{ NULL,          NULL,       NULL,           WTYPE "TOOLBAR",  0,         1,          0,          0,         -1 },
	{ NULL,          NULL,       NULL,           WTYPE "SPLASH",   0,         1,          0,          0,         -1 },
	{ "St",          NULL,       NULL,           NULL,             0,         0,          1,          0,         -1 },
  { "st-256color", NULL,       NULL,           NULL,             0,         0,          1,          0,         -1 },
	{ "Alacritty",   NULL,       NULL,           NULL,             1 << 1,    0,          1,          0,         -1 },
  { "kitty",       NULL,       NULL,           NULL,             1 << 1,    0,          1,          0,         -1 },
  { "xterm",       NULL,       NULL,           NULL,             1 << 1,    0,          1,          0,         -1 },
	{ NULL,          NULL,       "Event Tester", NULL,             0,         0,          0,          1,         -1 }, /* xev */

	/* App-specific rules -- pls ducking work */
	{ "firefox-esr", NULL,       NULL,           NULL,             1 << 0,    0,          0,          0,         -1 }, 
	{ "Io.github.ungoogled_software.ungoogled_chromium", NULL,       NULL,           NULL,             1 << 0,    0,          0,          0,         -1 },  //not pretty thanks fucking flatpak
	{ "VSCodium",    NULL,       NULL,           NULL,             1 << 1,    0,          0,          0,         -1 }, 
	{ "Virt-manager",NULL,       NULL,           NULL,             1 << 1,    0,          0,          0,         -1 },  
	{ "Pcmanfm",     NULL,       NULL,           NULL,             1 << 5,    0,          0,          0,         -1 }, 
	{ "Xarchiver",   NULL,       NULL,           NULL,             1 << 5,    0,          0,          0,         -1 }, 
	{ "ark",         NULL,       NULL,           NULL,             1 << 5,    0,          0,          0,         -1 }, 
	{ "libreoffice", NULL,       NULL,           NULL,             1 << 5,    0,          0,          0,         -1 }, 
	{ "steam",       NULL,       NULL,           NULL,             1 << 4,    0,          0,          0,         -1 }, 
	{ "heroic",      NULL,       NULL,           NULL,             1 << 4,    0,          0,          0,         -1 }, 
	{ "retroarch",   NULL,       NULL,           NULL,             1 << 4,    0,          0,          0,         -1 }, 
	{ "osu!",        NULL,       NULL,           NULL,             1 << 4,    0,          0,          0,         -1 }, 
	{ "vesktop",     NULL,       NULL,           NULL,             1 << 3,    0,          0,          0,         -1 }, 
	{ "Spotify",     NULL,       NULL,           NULL,             1 << 2,    0,          0,          0,         -1 }, 
	{ "Cider",       NULL,       NULL,           NULL,             1 << 2,    0,          0,          0,         -1 }, 
	{ "Gimp",        NULL,       NULL,           NULL,             1 << 6,    1,          0,          0,         -1 }, 
	{ "kdenlive",    NULL,       NULL,           NULL,             1 << 6,    0,          0,          0,         -1 },
	{ "obs",         NULL,       NULL,           NULL,             1 << 6,    0,          0,          0,         -1 }, 
	{ "Flatseal",    NULL,       NULL,           NULL,             1 << 8,    0,          0,          0,         -1 }, 
	{ "Bitwarden",   NULL,       NULL,           NULL,             1 << 8,    0,          0,          0,         -1 }, 
	{ "Io.ente.auth",NULL,       NULL,           NULL,             1 << 8,    0,          0,          0,         -1 }, 
	{ "KeePassXC",   NULL,       NULL,           NULL,             1 << 8,    0,          0,          0,         -1 }, 
	{ "openrgb",     NULL,       NULL,           NULL,             1 << 7,    0,          0,          0,         -1 }, 
};
	
/* layout(s) */
static const float mfact     = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "[M]",      monocle },
	{ "[@]",      spiral },
	{ "[\\]",     dwindle },
	{ "D[]",      deck },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "HHH",      grid },
	{ "###",      nrowgrid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "|M|",      centeredmaster },
	{ ">M>",      centeredfloatingmaster },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ NULL,       NULL },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG)                                                                                               \
       &((Keychord){1, {{MODKEY, KEY}},                                        view,           {.ui = 1 << TAG} }), \
       &((Keychord){1, {{MODKEY|ControlMask, KEY}},                            toggleview,     {.ui = 1 << TAG} }), \
       &((Keychord){1, {{MODKEY|ShiftMask, KEY}},                              tag,            {.ui = 1 << TAG} }), \
       &((Keychord){1, {{MODKEY|ControlMask|ShiftMask, KEY}},                  toggletag,      {.ui = 1 << TAG} }),

/* helper for spawning shell commands */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* --- Commands --- */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_normbg, "-nf", col_normfg, "-sb", col_selbg, "-sf", col_selfg, NULL };
static const char *termcmd[]  = { "st", NULL };

/* Applications (Office & Productivity) */
static const char *arkcmd[] = { "ark", NULL };
static const char *bitwardencmd[] = { "flatpak", "run", "com.bitwarden.desktop", NULL };
static const char *gnucashcmd[] = { "flatpak", "run", "org.gnucash.GnuCash", NULL };
static const char *keepassxccmd[] = { "keepassxc", NULL };
static const char *libreofficecmd[] = { "flatpak", "run", "org.libreoffice.LibreOffice", NULL };
static const char *obsidiancmd[] = { "flatpak", "run", "md.obsidian.Obsidian", NULL };
static const char *xarchivercmd[] = { "xarchiver", NULL };

/* Configuration & System Settings */
static const char *lxappearancecmd[] = { "lxappearance", NULL };
static const char *bluemancmd[] = { "blueman-manager", NULL };
static const char *pavucontrolcmd[] = { "pavucontrol", NULL };
static const char *fontmanagercmd[] = { "font-manager", NULL };
static const char *nmconnectcmd[] = { "nm-connection-editor", NULL };
static const char *printercmd[] = { "system-config-printer", NULL };
static const char *nvidiacmd[] = { "nvidia-settings", NULL };
static const char *flatsealcmd[] = { "flatpak", "run", "com.github.tchx84.Flatseal", NULL };

/* Development */
static const char *codecmd[] = { "flatpak", "run", "com.vscodium.codium", NULL };
static const char *nvimcmd[] = { "st", "-e", "nvim", NULL };
static const char *virtmanagercmd[] = { "virt-manager", NULL };

/* Games */
static const char *steamcmd[] = { "steam", NULL };
static const char *heroiccmd[] = { "flatpak", "run", "com.heroicgameslauncher.hgl", NULL };
static const char *prismcmd[] = { "flatpak", "run", "org.prismlauncher.PrismLauncher", NULL };
static const char *retroarchcmd[] = { "flatpak", "run", "org.libretro.RetroArch", NULL };
static const char *osucmd[] = { "flatpak", "run", "sh.ppy.osu", NULL };

/* Media, Graphics & Creative */
static const char *gimpcmd[] = { "flatpak", "run", "org.gimp.GIMP", NULL };
static const char *kdenlivecmd[] = { "flatpak", "run", "org.kde.kdenlive", NULL };
static const char *ncmpcppcmd[] = { "st", "-e", "ncmpcpp", NULL };
static const char *obscmd[] = { "flatpak", "run", "com.obsproject.Studio", NULL };
static const char *cidercmd[] = { "flatpak", "run", "sh.cider.genten", NULL };
static const char *spotifycmd[] = { "spotify-adblock", NULL };
static const char *vesktopcmd[] = { "flatpak", "run", "dev.vencord.Vesktop", NULL };

/* Network & Internet */
static const char *webcmd[] = { "firefox-esr", NULL };
static const char *chromiumcmd[] = { "flatpak", "run", "io.github.ungoogled_software.ungoogled_chromium", NULL };
static const char *newsboatcmd[] = { "st", "-e", "newsboat", NULL };
static const char *profanitycmd[] = { "st", "-e", "profanity", NULL };

/* System Utilities */
static const char *fmcmd[] = { "pcmanfm", NULL };
static const char *fmcmdapp[] = { "pcmanfm", "menu://applications/", NULL };
static const char *lfcmd[] = { "st", "-e", "lf", NULL };
static const char *htopcmd[] = { "st", "-e", "htop", NULL };
static const char *nvtopcmd[] = { "st", "-e", "nvtop", NULL };
static const char *gpartedcmd[] = { "pkexec", "gparted", NULL };
static const char *synapticcmd[] = { "pkexec", "synaptic", NULL };

static Keychord *keychords[] = {
	/* Keys                                     function        argument */

    /* --- Primary Launchers --- */
	&((Keychord){1, {{MODKEY, XK_p}},                                       spawn,          {.v = dmenucmd } }),
	&((Keychord){1, {{MODKEY|ShiftMask, XK_Return}},                        spawn,          {.v = termcmd } }),
	&((Keychord){1, {{MODKEY, XK_e}},                                       spawn,          {.v = fmcmd } }),
	&((Keychord){1, {{MODKEY|ShiftMask, XK_e}},                             spawn,          {.v = lfcmd } }),
	&((Keychord){1, {{MODKEY|ControlMask, XK_e}},                           spawn,          {.v = fmcmdapp } }),

    /* --- Keychords --- */
    /* MODKEY + a -> Applications */
    &((Keychord){2, {{MODKEY, XK_a}, {0, XK_a}},                            spawn,          {.v = arkcmd} }),
    &((Keychord){2, {{MODKEY, XK_a}, {0, XK_b}},                            spawn,          {.v = bitwardencmd} }),
    &((Keychord){2, {{MODKEY, XK_a}, {0, XK_c}},                            spawn,          {.v = gnucashcmd} }),
    &((Keychord){2, {{MODKEY, XK_a}, {0, XK_k}},                            spawn,          {.v = keepassxccmd} }),
    &((Keychord){2, {{MODKEY, XK_a}, {0, XK_l}},                            spawn,          {.v = libreofficecmd} }),
    &((Keychord){2, {{MODKEY, XK_a}, {0, XK_o}},                            spawn,          {.v = obsidiancmd} }), 
    &((Keychord){2, {{MODKEY, XK_a}, {0, XK_x}},                            spawn,          {.v = xarchivercmd} }),
    &((Keychord){1, {{MODKEY|ControlMask, XK_d}},                           spawndefault, {0} }),


    /* MODKEY + c -> Configuration */
    &((Keychord){2, {{MODKEY, XK_c}, {0, XK_a}},                            spawn,          {.v = lxappearancecmd} }),
    &((Keychord){2, {{MODKEY, XK_c}, {0, XK_b}},                            spawn,          {.v = bluemancmd} }),
    &((Keychord){2, {{MODKEY, XK_c}, {0, XK_d}},                            spawn,          {.v = pavucontrolcmd} }),
    &((Keychord){2, {{MODKEY, XK_c}, {0, XK_f}},                            spawn,          {.v = fontmanagercmd} }),
    &((Keychord){2, {{MODKEY, XK_c}, {0, XK_n}},                            spawn,          {.v = nmconnectcmd} }),
    &((Keychord){2, {{MODKEY, XK_c}, {0, XK_p}},                            spawn,          {.v = printercmd} }),
    &((Keychord){2, {{MODKEY, XK_c}, {0, XK_s}},                            spawn,          {.v = nvidiacmd} }),
    &((Keychord){2, {{MODKEY, XK_c}, {0, XK_t}},                            spawn,          {.v = flatsealcmd} }),

    /* MODKEY + d -> Development */
    &((Keychord){2, {{MODKEY, XK_d}, {0, XK_c}},                            spawn,          {.v = codecmd} }),
    &((Keychord){2, {{MODKEY, XK_d}, {0, XK_n}},                            spawn,          {.v = nvimcmd} }),
    &((Keychord){2, {{MODKEY, XK_d}, {0, XK_v}},                            spawn,          {.v = virtmanagercmd} }),

    /* MODKEY + g -> Games */
    &((Keychord){2, {{MODKEY, XK_g}, {0, XK_s}},                            spawn,          {.v = steamcmd} }),
    &((Keychord){2, {{MODKEY, XK_g}, {0, XK_h}},                            spawn,          {.v = heroiccmd} }),
    &((Keychord){2, {{MODKEY, XK_g}, {0, XK_p}},                            spawn,          {.v = prismcmd} }),
    &((Keychord){2, {{MODKEY, XK_g}, {0, XK_r}},                            spawn,          {.v = retroarchcmd} }),
    &((Keychord){2, {{MODKEY, XK_g}, {0, XK_o}},                            spawn,          {.v = osucmd} }),

    /* MODKEY + m -> Media & Graphics */
    &((Keychord){2, {{MODKEY, XK_m}, {0, XK_g}},                            spawn,          {.v = gimpcmd} }),
    &((Keychord){2, {{MODKEY, XK_m}, {0, XK_k}},                            spawn,          {.v = kdenlivecmd} }),
    &((Keychord){2, {{MODKEY, XK_m}, {0, XK_n}},                            spawn,          {.v = ncmpcppcmd} }),
    &((Keychord){2, {{MODKEY, XK_m}, {0, XK_o}},                            spawn,          {.v = obscmd} }),
    &((Keychord){2, {{MODKEY, XK_m}, {0, XK_s}},                            spawn,          {.v = spotifycmd} }),
    &((Keychord){2, {{MODKEY, XK_m}, {0, XK_c}},                            spawn,          {.v = cidercmd} }),
    &((Keychord){2, {{MODKEY, XK_m}, {0, XK_v}},                            spawn,          {.v = vesktopcmd} }),

    /* MODKEY + n -> Network */
    &((Keychord){2, {{MODKEY|ControlMask, XK_n}, {0, XK_b}},                            spawn,          {.v = webcmd} }), 
    &((Keychord){2, {{MODKEY|ControlMask, XK_n}, {0, XK_c}},                            spawn,          {.v = chromiumcmd} }), 
    &((Keychord){2, {{MODKEY|ControlMask, XK_n}, {0, XK_n}},                            spawn,          {.v = newsboatcmd} }), 
    &((Keychord){2, {{MODKEY|ControlMask, XK_n}, {0, XK_p}},                            spawn,          {.v = profanitycmd} }), 

    /* MODKEY + s -> System Utilities */
    &((Keychord){2, {{MODKEY, XK_s}, {0, XK_h}},                            spawn,          {.v = htopcmd } }),
    &((Keychord){2, {{MODKEY, XK_s}, {0, XK_n}},                            spawn,          {.v = nvtopcmd } }),
    &((Keychord){2, {{MODKEY, XK_s}, {0, XK_g}},                            spawn,          {.v = gpartedcmd } }),
    &((Keychord){2, {{MODKEY, XK_s}, {0, XK_s}},                            spawn,          {.v = synapticcmd } }),
    //&((Keychord){2, {{MODKEY, XK_s}, {0, XK_x}},                            spawn,          SHCMD("choice=$(echo -e 'Shutdown\\nReboot\\nLock' | dmenu -i -p 'Power:'); [ \"$choice\" ] && case \"$choice\" in Shutdown) systemctl poweroff ;; Reboot) systemctl reboot ;; Lock) xscreensaver-command -lock ;; esac") }),
    &((Keychord){2, {{MODKEY, XK_s}, {0, XK_x}},                            spawn,          SHCMD("/home/liv/.local/scripts/dmenu-logout") }),  

	/* Screenshots */
    &((Keychord){1, {{0, XK_Print}},                                        spawn,          SHCMD("scrot '%Y-%m-%d-%T-screenshot.png' -e 'mkdir -p ~/Pictures/screenshots && mv $f ~/Pictures/screenshots/'") }),
    &((Keychord){1, {{ShiftMask, XK_Print}},                                spawn,          SHCMD("scrot -s '%Y-%m-%d-%T-screenshot.png' -e 'mkdir -p ~/Pictures/screenshots && mv $f ~/Pictures/screenshots/'") }),
    &((Keychord){1, {{ShiftMask, XK_Print}},                                spawn,          SHCMD("scrot -s '%Y-%m-%d-%T-screenshot.png' -e 'mkdir -p ~/Pictures/screenshots && mv $f ~/Pictures/screenshots/'") }),
    &((Keychord){1, {{MODKEY|ShiftMask, XK_s}},                             spawn,          SHCMD("scrot -s - | xclip -selection clipboard -target image/png -i") }),
  

	/* --- Default dwm bindings --- */
	/* Window management */
	&((Keychord){1, {{MODKEY, XK_b}},                                       togglebar,      {0} }),
	&((Keychord){1, {{MODKEY, XK_j}},                                       focusstack,     {.i = +1 } }),
	&((Keychord){1, {{MODKEY, XK_k}},                                       focusstack,     {.i = -1 } }),
	&((Keychord){1, {{MODKEY, XK_i}},                                       incnmaster,     {.i = +1 } }),
	&((Keychord){1, {{MODKEY|ShiftMask, XK_i}},                             incnmaster,     {.i = -1 } }),
	&((Keychord){1, {{MODKEY, XK_h}},                                       setmfact,       {.f = -0.05} }),
	&((Keychord){1, {{MODKEY, XK_l}},                                       setmfact,       {.f = +0.05} }),
	&((Keychord){1, {{MODKEY|ShiftMask, XK_h}},                             setcfact,       {.f = +0.25} }), //FIX ME
	&((Keychord){1, {{MODKEY|ShiftMask, XK_l}},                             setcfact,       {.f = -0.25} }), //FIXME
	&((Keychord){1, {{MODKEY|ShiftMask, XK_o}},                             setcfact,       {.f =  0.00} }),
	&((Keychord){1, {{MODKEY, XK_Return}},                                  zoom,           {0} }),
	&((Keychord){1, {{MODKEY, XK_Tab}},                                     view,           {0} }),
	&((Keychord){1, {{MODKEY|ShiftMask, XK_c}},                             killclient,     {0} }),
	&((Keychord){1, {{MODKEY, XK_t}},                                       setlayout,      {.v = &layouts[0]} }),
	&((Keychord){1, {{MODKEY, XK_f}},                                       setlayout,      {.v = &layouts[1]} }),
	&((Keychord){1, {{MODKEY, XK_space}},                                   setlayout,      {0} }),
	&((Keychord){1, {{MODKEY|ShiftMask, XK_space}},                         togglefloating, {0} }),
	&((Keychord){1, {{MODKEY|ShiftMask, XK_f}},                             togglefullscreen, {0} }),
	&((Keychord){1, {{MODKEY, XK_f}},                                       togglefakefullscreen, {0} }),
  &((Keychord){1, {{MODKEY|ControlMask, XK_comma}},                       cyclelayout,    {.i = -1} }),
	&((Keychord){1, {{MODKEY|ControlMask, XK_period}},                      cyclelayout,    {.i = +1} }),

	/* Monitor & tag management */
	&((Keychord){1, {{MODKEY, XK_0}},                                       view,           {.ui = ~0 } }),
	&((Keychord){1, {{MODKEY|ShiftMask, XK_0}},                             tag,            {.ui = ~0 } }), //FIXME
	&((Keychord){1, {{MODKEY, XK_comma}},                                   focusmon,       {.i = -1 } }),
	&((Keychord){1, {{MODKEY, XK_period}},                                  focusmon,       {.i = +1 } }),
	&((Keychord){1, {{MODKEY|ShiftMask, XK_comma}},                         tagmon,         {.i = -1 } }), 
	&((Keychord){1, {{MODKEY|ShiftMask, XK_period}},                        tagmon,         {.i = +1 } }), 

	/* Gaps control (re-added individual controls) */
	&((Keychord){1, {{MODKEY|Mod1Mask, XK_u}},                              incrgaps,       {.i = +1 } }),
	&((Keychord){1, {{MODKEY|Mod1Mask|ShiftMask, XK_u}},                    incrgaps,       {.i = -1 } }),
	&((Keychord){1, {{MODKEY|Mod1Mask, XK_o}},                              incrogaps,      {.i = +1 } }),
	&((Keychord){1, {{MODKEY|Mod1Mask|ShiftMask, XK_o}},                    incrogaps,      {.i = -1 } }),
    &((Keychord){1, {{MODKEY|Mod1Mask, XK_i}},                              incrigaps,      {.i = +1 } }),
	&((Keychord){1, {{MODKEY|Mod1Mask|ShiftMask, XK_i}},                    incrigaps,      {.i = -1 } }),
    &((Keychord){1, {{MODKEY|Mod1Mask, XK_6}},                              incrihgaps,     {.i = +1 } }),
	&((Keychord){1, {{MODKEY|Mod1Mask|ShiftMask, XK_6}},                    incrihgaps,     {.i = -1 } }),
	&((Keychord){1, {{MODKEY|Mod1Mask, XK_7}},                              incrivgaps,     {.i = +1 } }),
	&((Keychord){1, {{MODKEY|Mod1Mask|ShiftMask, XK_7}},                    incrivgaps,     {.i = -1 } }),
	&((Keychord){1, {{MODKEY|Mod1Mask, XK_8}},                              incrohgaps,     {.i = +1 } }),
	&((Keychord){1, {{MODKEY|Mod1Mask|ShiftMask, XK_8}},                    incrohgaps,     {.i = -1 } }),
	&((Keychord){1, {{MODKEY|Mod1Mask, XK_9}},                              incrovgaps,     {.i = +1 } }),
	&((Keychord){1, {{MODKEY|Mod1Mask|ShiftMask, XK_9}},                    incrovgaps,     {.i = -1 } }),
	&((Keychord){1, {{MODKEY|Mod1Mask, XK_0}},                              togglegaps,     {0} }),
	&((Keychord){1, {{MODKEY|Mod1Mask|ShiftMask, XK_0}},                    defaultgaps,    {0} }),

	/* Opacity control */
	&((Keychord){1, {{MODKEY, XK_o}},                                       toggleopacity,  {0} }),

	/* Focus same class */
	&((Keychord){1, {{MODKEY, XK_n}},                                       focussame,      {.i = +1 } }),
	&((Keychord){1, {{MODKEY|ShiftMask, XK_n}},                             focussame,      {.i = -1 } }),

	/* Quit dwm */
	&((Keychord){1, {{MODKEY|ShiftMask, XK_q}},                             quit,           {0} }),
	&((Keychord){1, {{MODKEY|ControlMask|ShiftMask, XK_q}},                 quit,           {1} }),

	/* Media keys - playerctl */
	&((Keychord){1, {{0, XF86XK_AudioPlay}},                                spawn,          SHCMD("playerctl play-pause") }),
	&((Keychord){1, {{0, XF86XK_AudioNext}},                                spawn,          SHCMD("playerctl next") }),
	&((Keychord){1, {{0, XF86XK_AudioPrev}},                                spawn,          SHCMD("playerctl previous") }),

	/* Media keys - volume */
    &((Keychord){1, {{0, XF86XK_AudioLowerVolume}}, spawn, SHCMD("amixer set Master 5%- unmute") }),
    &((Keychord){1, {{0, XF86XK_AudioRaiseVolume}}, spawn, SHCMD("amixer set Master 5%+ unmute") }),
    &((Keychord){1, {{0, XF86XK_AudioMute}},        spawn, SHCMD("amixer set Master toggle") }),

	/* Tag keys */
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
};


/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
