// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// bootstrapの使用
import 'bootstrap';
import '../stylesheets/application';
import '@fortawesome/fontawesome-free/js/all';

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import 'hammerjs';

import '../src/profile_image_upload';
import '../src/swipe';

// require("src/profile_image_upload");
// require("src/swipe")

Rails.start()
Turbolinks.start()
ActiveStorage.start()
