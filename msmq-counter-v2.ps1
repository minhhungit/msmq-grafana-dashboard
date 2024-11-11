param (
    [int]$Port = 9188
)

try {
    # Define the HTTP listener
    $listener = [System.Net.HttpListener]::new()
    $listener.Prefixes.Add("http://*:$Port/metrics/")
    $listener.Start()
    Write-Output "Listening on http://*:$Port/metrics/"

    while ($true) {
        try {
            # Wait for an incoming request
            $context = $listener.GetContext()
            $response = $context.Response

            # Collect MSMQ data
            $msmqData = Get-WmiObject -Namespace "root\cimv2" -Class "Win32_PerfFormattedData_msmq_MSMQQueue" |
                Where-Object { $_.Name -ne "Computer Queues" -and $_.Name -notlike "*admin_queue$" } |
                Select-Object @{Name="QueueName";Expression={$_.Name}},
                              @{Name="MessageCount";Expression={[Int64]$_.MessagesInQueue}},
							  #@{Name="JournalMessageCount";Expression={[Int64]$_.MessagesinJournalQueue}},
                              @{Name="BytesInQueue";Expression={[Int64]$_.BytesInQueue}},
							  #@{Name="BytesinJournalQueue";Expression={[Int64]$_.BytesinJournalQueue}},
                              @{Name="MachineName";Expression={$_.__SERVER}}                              

            # Function to map state to numeric value
            function Convert-StateToNumeric($state) {
                switch ($state) {
                    "MQ_QUEUE_STATE_CONNECTED" { return 1 }
                    "MQ_QUEUE_STATE_DISCONNECTED" { return 0 }
                    default { return -1 }
                }
            }

            # Format the data for Prometheus
            $metrics = @()
            foreach ($queue in $msmqData) {
                $queueName = $queue.QueueName -replace "\\", "\\\\"
                $machineName = $queue.MachineName -replace "\\", "\\\\"

                $metrics += "msmq_queue_message_count{queue_name=`"$queueName`",machine_name=`"$machineName`"} $($queue.MessageCount)"
                $metrics += "msmq_queue_bytes_in_queue{queue_name=`"$queueName`",machine_name=`"$machineName`"} $($queue.BytesInQueue)"
                #$metrics += "msmq_queue_journal_message_count{queue_name=`"$queueName`",machine_name=`"$machineName`"} $($queue.JournalMessageCount)"
            }
            
            $metricsOutput = $metrics -join "`n"

            # Write the metrics to the response
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($metricsOutput)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            $response.OutputStream.Close()
        } catch {
            Write-Error "Error processing request: $_"
        }
    }
} catch {
    Write-Error "Failed to start HTTP listener: $_"
} finally {
    if ($listener) {
        $listener.Stop()
        $listener.Close()
    }
}
