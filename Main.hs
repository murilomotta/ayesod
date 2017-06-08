{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Main where
import Yesod
import Yesod.Static
import Foundation
import Application
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text
import Database.Persist.Postgresql

{-
dbname    = "ddttg90fgo9gpb"
host      = "ec2-107-20-198-81.compute-1.amazonaws.com"
user      = "ywvzmcgbsclczx"
password  = "FcAhRNG7b35bTYpGVCTSx0vVkG"
port      = "5432"


-- connStr :: Text

connStr = 
      "dbname=" ++ dbname ++ 
      " host="  ++ host   ++
      " user="  ++ user   ++
      " password=" ++ password ++ 
      " port="  ++ port
                   
-}                          

connStr = "dbname=ddttg90fgo9gpb host=ec2-107-20-198-81.compute-1.amazonaws.com user=ywvzmcgbsclczx password=FcAhRNG7b35bTYpGVCTSx0vVkG port=5432"

-- codenvy 3000
-- warp 8080 App

main::IO()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do 
       runSqlPersistMPool (runMigration migrateAll) pool 
       t@(Static settings) <- static "static"
       warp 3000 (Sitio t pool)
