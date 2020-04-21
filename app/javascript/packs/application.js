import ReactOnRails from 'react-on-rails';
import UserInfo from '../components/UserInfo';
import Home from '../components/Pages';

// This is how react_on_rails can see the HelloWorld in the browser.
ReactOnRails.register({
  UserInfo,
  Home
});
