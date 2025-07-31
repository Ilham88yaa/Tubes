const bcrypt = require('bcrypt');

const hash = '$2a$10$yW48Be1ONfvuM0M35GPF8e7YgICzVduff7s8VZyBQvFFwO9XzICfu';
const passwordList = ['admin123', 'password', '123456', 'admin', 'admin1234'];

(async () => {
  for (let pw of passwordList) {
    const match = await bcrypt.compare(pw, hash);
    if (match) {
      console.log(`Password yang cocok: ${pw}`);
    }
  }
})();
