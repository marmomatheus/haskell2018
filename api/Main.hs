{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
import Foundation
import Application () -- for YesodDispatch instance
import Yesod
import Data.Text
import Control.Monad.Logger (runStdoutLoggingT)
import Database.Persist.Postgresql
import Network.HTTP.Types.Status

connStr :: ConnectionString
connStr = "dbname=d7t84g8ge25cg5 host=ec2-23-23-142-5.compute-1.amazonaws.com user=gxnhjzmeoahuuv password=e22533fa863ae48f7da2d8a1f645c7ea84a29d56382356b27384f472f1ae319b port=5432"

main::IO()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do 
       runSqlPersistMPool (runMigration migrateAll) pool 
       warp 8080 (App pool)