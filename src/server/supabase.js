const { createClient } = require('@supabase/supabase-js')
require('dotenv').config()

// These are your 2 values from your Supabase project we copied earlier, place them here
// You can read more about what keys can access & do here: https://supabase.com/docs/guides/api/api-keys
const supabaseUrl = 'https://ezknlsbpkaxdgfnkqjwo.supabase.co'
const supabaseKey = process.env['supabase_service_key']
const supabase = createClient(supabaseUrl, supabaseKey)

module.exports = supabase