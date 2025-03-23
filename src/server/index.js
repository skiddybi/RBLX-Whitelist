// This code is a SHIM, do NOT use in actual projects

const express = require('express');
const supabase = require('./supabase');
const app = express();
const port = 3000;

app.use(express.json());

// For ""security"" reasons, we only allow requests with these fingerprints; this can also be used to enforce the whitelist to only run on specific executors.
const allowed_fingerprints = [
  'wave-fingerprint',
  'sirhurt-fingerprint',
];

app.post('/whitelist', async (req, res) => {
  const { whitelistkey, firstValue, secondValue } = req.body;
  const headers = req.headers;
  let foundFingerprint = null;

  for (const fingerprint of allowed_fingerprints) {
    if (headers[fingerprint]) {
      foundFingerprint = headers[fingerprint];
      break;
    }
  }

  // Missing values --> most likely an illegal request / unsupported executor
  if (!foundFingerprint || !whitelistkey || !firstValue || !secondValue) {
    return res.json({ message: "???" });
  }

  // fx 1 & fx 2
  const newFirstValue = (Math.sin(firstValue * 2 + 3) * 4) + 10;
  const newSecondValue = (Math.asin((secondValue - 10) / 4) - 3) / 2;


  const { data } = await supabase
    .from('whitelist')
    .select('*')
    .eq('whitelistkey', whitelistkey)
    .single();

  if (data) {
    if (data.fingerprint === foundFingerprint) {
    // Case 1: The whitelist entry has the same fingerprint as the one we found
      return res.json(
        { valid: true, newFirstValue: newFirstValue ,newSecondValue: newSecondValue, decKey: "d5e03252767d767f6aab5730663c4563" }
      );
    } else if (data.fingerprint === null) {
      // Case 2: The whitelist entry has no set fingerprint, so we set one
      const { error: updateError } = await supabase
        .from('whitelist')
        .update({ fingerprint: foundFingerprint })
        .eq('whitelistkey', whitelistkey);

      if (updateError) {
        return res.json({ valid: false });
      }

      return res.json(
        { valid: true, newFirstValue: newFirstValue ,newSecondValue: newSecondValue, decKey: "d5e03252767d767f6aab5730663c4563" }
      );

    } else {
      // Case 3: The whitelist entry has a different fingerprint than the one we found
      return res.json({ valid: false });
    }
  } else {
    // Case 4: The whitelist entry does not exist at all
    return res.json({ valid: false });
  }
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
