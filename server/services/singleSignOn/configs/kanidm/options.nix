{ config, lib, pkgs-unstable, pkgs-default, ... }:
let
  custom-css = ''
    :root {
      --totp-width-and-height: 30px;
      --totp-stroke-width: 60px;
      --navbar-colors-transition: color 0.15s ease-in-out,
        background-color 0.15s ease-in-out, border-color 0.15s ease-in-out;
    }

    @media (prefers-reduced-motion: reduce) {
      --navbar-colors-transition: none;
    }

    html,
    body {
      height: 100%;
    }

    .form-cred-reset-body {
      max-width: 500px;
    }

    #settings-window .form-cred-reset-body {
      max-width: unset;
    }

    .form-signin {
      padding: 4rem;
      max-width: 400px;
      width: 100%;
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      background: rgba(255, 255, 255, 0.15);
      backdrop-filter: blur(2px) saturate(180%);
      border: 1px solid rgba(255, 255, 255, 0.8);
      border-radius: 2rem;
      box-shadow: 0 8px 32px rgba(31, 38, 135, 0.2), 
                  inset 0 4px 20px rgba(255, 255, 255, 0.3);
    }

    .form-signin::after {
      content: \'\';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 2rem;
      backdrop-filter: blur(1px);
      box-shadow: inset -10px -8px 0px -11px rgba(255, 255, 255, 1),
                  inset 0px -9px 0px -8px rgba(255, 255, 255, 1);
      opacity: 0.6;
      z-index: -1;
      filter: blur(1px) drop-shadow(10px 4px 6px black) brightness(115%);
    }

    /*
    * Bootstrap 5.3 fix for input-group validation
    * :has checks that a child can be selected with the selector
    * + selects the next sibling.
    */
    .was-validated .input-group:has(.form-control:invalid) + .invalid-feedback {
      display: block !important;
    }

    /*
    * Sidebar
    */

    .side-menu {
      min-width: 180px;
    }

    .side-menu-item {
      --icon-size: 24px;
      padding: 0.4rem 0.7rem;
      text-decoration: none;

      &.active {
        font-weight: 600;
      }

      &:hover,
      &.active {
        background-color: var(--bs-tertiary-bg);
      }

      .icon-container img {
        filter: invert(40%);
        width: 100%;
        height: 100%;
        object-fit: contain;
      }
    }

    /*
    * Navbar
    */
    .navbar-toggle-icon {
      width: 30px;
      height: 30px;
      transition: var(--navbar-colors-transition);
    }
    nav a.navbar-brand {
      color: var(--bs-navbar-color);
      transition: var(--navbar-colors-transition);
    }

    .kanidm_logo {
      width: 12em;
      height: 12em;
    }

    .identity-verification-container {
      display: flex;
      flex-direction: column;
      max-width: fit-content;
      align-items: center;
      margin: auto;
    }

    .totp-display-container {
      padding: 5px 10px;
      display: flex;
      flex-direction: row;
      max-width: fit-content;
      align-items: center;
      margin: auto;
      border-radius: 15px;
      background-color: #21252915;
      box-shadow:
        -5px -5px 11px #ededed,
        5px 5px 11px #ffffff;
      margin: 15px;
    }

    .totp-display {
      font-size: 35px;
      margin: 10px;
    }

    .totp-timer {
      margin: 10px;
      position: relative;
      height: var(--totp-width-and-height);
      width: var(--totp-width-and-height);
    }

    /* Removes SVG styling that would hide the time label */
    .totp-timer__circle {
      fill: none;
      stroke: none;
    }

    .totp-timer__path-remaining {
      stroke-width: var(--totp-stroke-width);

      /* Makes sure the animation starts at the top of the circle */
      transform: rotate(90deg);
      transform-origin: center;

      /* One second aligns with the speed of the countdown timer */
      transition: 1s linear all;

      stroke: currentColor;
    }

    .totp-timer__svg {
      transform: scaleX(-1);
    }

    .totp-timer__path-remaining.green {
      color: var(--bs-success);
    }

    .totp-timer__path-remaining.orange {
      color: var(--bs-warning);
    }

    .totp-timer__path-remaining.red {
      color: var(--bs-danger);
    }

    .totp-timer__path-remaining.no-transition {
      -webkit-transition: none !important;
      -moz-transition: none !important;
      -o-transition: none !important;
      transition: none !important;
    }

    .card {
      background: rgba(255, 255, 255, 0.15);
      backdrop-filter: blur(2px) saturate(180%);
      border: 1px solid rgba(255, 255, 255, 0.8);
      border-radius: 2rem;
      box-shadow: 0 8px 32px rgba(31, 38, 135, 0.2), 
                  inset 0 4px 20px rgba(255, 255, 255, 0.3);
    }

    .card::after {
      content: \'\';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 2rem;
      backdrop-filter: blur(1px);
      box-shadow: inset -10px -8px 0px -11px rgba(255, 255, 255, 1),
                  inset 0px -9px 0px -8px rgba(255, 255, 255, 1);
      opacity: 0.6;
      z-index: -1;
      filter: blur(1px) drop-shadow(10px 4px 6px black) brightness(115%);
    }

    .card > a {
      height: 150px;
    }

    .oauth2-img {
      max-width: 100%;
      max-height: 90%;
      padding: 10px;
      height: 100%;
    }

    .btn-tiny {
      --bs-btn-padding-y: 0.05rem;
      --bs-btn-padding-x: 0.4rem;
      --bs-btn-font-size: 0.75rem;
    }

    #cred-update-commit-bar {
      display: block;
      /*
      position: fixed;
      bottom: .5rem;
      left: 50%;
      transform: translateX(-50%);
      */
      background: white;
    }

    .icon-container {
      padding: 2px;
      width: var(--icon-size);
      height: var(--icon-size);
    }

    .ssh-list-icon {
      --icon-size: 32px;
      width: var(--icon-size);
      height: var(--icon-size);
      transform: rotate(35deg);
    }

    .cursor-pointer:hover {
      cursor: pointer;
    }

    .footer {
      background: rgba(255, 255, 255, 0.15);
      backdrop-filter: blur(2px) saturate(180%);
      opacity: 0.8;
    }

    @media (forced-colors: active) and (prefers-color-scheme: light) {
      .form-check-input:checked {
        background-color: ButtonText !important;
      }
      .form-switch .form-check-input:checked {
        forced-color-adjust: none;
      }
    }

    @media (forced-colors: active) {
      .form-check-input:focus {
        outline: 1px solid Highlight;
      }
      .form-check-input:disabled ~ .form-check-label,
      .form-check-input[disabled] ~ .form-check-label {
        color: GrayText;
      }
      .form-select:focus {
        outline: 1px solid transparent;
      }
      .form-switch .form-check-input {
        border: 1px solid;
      }
    }
  '';

  cssFile = pkgs-default.writeText "custom-style.css" custom-css;
in
{
  config.server.services.singleSignOn.availableConfigs = [ "kanidm" ];

  options.server.services.singleSignOn.kanidm = {

    basePackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs-unstable.kanidmWithSecretProvisioning_1_8;
      description = "The base Kanidm package to use for the SSO service.";
    };

    customStyling = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable custom styling for Kanidm SSO login pages.";
      };

      favicon = lib.mkOption {
        type = lib.types.path;
        default = ../../bin/icons/holocron.png;
        description = "Path to the favicon for Kanidm SSO pages. Has to be a PNG image.";
      };

      customCss = lib.mkOption {
        type = lib.types.path;
        default = cssFile;
        description = "Custom CSS to apply to Kanidm SSO pages.";
      };

      backgroundImage = lib.mkOption {
        type = lib.types.path;
        default = ../../bin/images/background.jpg;
        description = "Path to the background image for Kanidm SSO pages.";
      };  
    };
  };
}